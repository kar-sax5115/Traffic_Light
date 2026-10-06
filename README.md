# Traffic Light Controller

A simple traffic light controller written in Verilog. It takes a 50 MHz board clock, divides it down to 1 Hz, and runs a four-state finite state machine (FSM) that cycles through **Red → Green → Yellow → All-Red**. A small decoder turns the current state into a 3-bit light output.

## Features

- Clock divider: 50 MHz input to a 1 Hz tick (parameterized, so it works with other clock frequencies)
- Four-state FSM with a separate, configurable duration for each state
- Combinational output decoder (state to 3-bit `light` bus)
- Active-low asynchronous reset
- Self-contained testbench with a scaled-down clock so simulation finishes quickly

## Repository Structure

| File | Description |
| --- | --- |
| `trafficlighttop.v` | Top-level module. Connects the clock divider, FSM and light decoder. |
| `clk_divider.v` | Divides the 50 MHz input clock down to 1 Hz. |
| `trafficfsm.v` | FSM that controls the state sequence and how long each state lasts. |
| `lightdecoder.v` | Converts the 2-bit FSM state into the 3-bit `light` output. |
| `tb_traffic_light.v` | Testbench for simulation. |

## How It Works

```
                 +-------------+  clk_1hz  +------------+  state[1:0]  +--------------+
 clk_50mhz ----> | clk_divider | --------> | trafficfsm | -----------> | lightdecoder | ----> light[2:0]
 rst_n ---+----> |             |           |            |              |              |
          |      +-------------+           +------------+              +--------------+
          +-------------------------------------^
```

### 1. Clock divider (`clk_divider.v`)

The module counts `CLK_FREQ / 2` input clock cycles (25,000,000 at 50 MHz, which is 0.5 s) and then toggles `clk_1hz`. Toggling every half second gives a 1 Hz output with a 1 second period.

### 2. Traffic FSM (`trafficfsm.v`)

The FSM runs on the 1 Hz clock, so each tick is one second. A `timer` counts ticks inside the current state, and when the state's time is up the FSM moves to the next state and resets the timer.

```
   +-----+     +-------+     +--------+     +--------+
   | RED | --> | GREEN | --> | YELLOW | --> | REDALL |
   +-----+     +-------+     +--------+     +--------+
      ^                                          |
      +------------------------------------------+
```

| State | Encoding | Duration (default) |
| --- | --- | --- |
| `RED` | `2'b00` | 10 s |
| `GREEN` | `2'b01` | 8 s |
| `YELLOW` | `2'b10` | 3 s |
| `REDALL` | `2'b11` | 1 s |

One full cycle takes **22 seconds** with the default timings. After reset the FSM starts in `RED`. Any unexpected state value falls back to `RED`.

### 3. Light decoder (`lightdecoder.v`)

| State | `light[2:0]` | Value |
| --- | --- | --- |
| `RED` | `3'b001` | 1 |
| `GREEN` | `3'b010` | 2 |
| `YELLOW` | `3'b100` | 4 |
| `REDALL` | `3'b011` | 3 |

## Top-Level Interface

Module: `trafficlighttop`

| Port | Direction | Width | Description |
| --- | --- | --- | --- |
| `clk_50mhz` | input | 1 | 50 MHz board clock |
| `rst_n` | input | 1 | Active-low asynchronous reset |
| `light` | output | 3 | Encoded light output (see table above) |

## Configuration

**Change the state durations** by editing the parameters in `trafficfsm.v` (values are in seconds, since the FSM runs on the 1 Hz clock):

```verilog
parameter RED_TIME = 10, GREEN_TIME = 8, YELLOW_TIME = 3, REDALL_TIME = 1;
```

**Use a different input clock** by changing the `CLK_FREQ` parameter of `clk_divider` (default `50_000_000`).

## Simulation

The testbench (`tb_traffic_light.v`) instantiates `trafficlighttop` and:

- Generates a 50 MHz clock (20 ns period)
- Holds reset low for 100 ns, then releases it
- Overrides `CLK_FREQ` to `50` with `defparam`, so the "1 Hz" clock becomes a 1 MHz clock. One second of design time takes only 1 µs of simulation time.
- Runs for 500 µs, which covers more than 22 full traffic light cycles
- Prints every change on `light` with `$monitor`

### Run with Icarus Verilog

```bash
iverilog -o traffic_sim clk_divider.v trafficfsm.v lightdecoder.v trafficlighttop.v tb_traffic_light.v
vvp traffic_sim
```

### Run with Vivado or ModelSim

Add all five `.v` files to a project, set `tb_traffic_light` as the simulation top module, and run the simulation.

## Running on Hardware

1. Set `trafficlighttop` as the top module.
2. Constrain `clk_50mhz` to a 50 MHz clock pin, `rst_n` to a push button (active-low), and `light[2:0]` to three LEDs.
3. Synthesize, implement and program the board.

Since `CLK_FREQ` defaults to 50 MHz, no code changes are needed for a 50 MHz board.
