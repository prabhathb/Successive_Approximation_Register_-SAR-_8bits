This is a very basic design of an eight bit successive approximation register type analog to digitla converter which is commonly used in low and mid range microcontrollers.

The SAR type ADC is popularly known as a hardware implementation of the binary search algorithm.

The design is done using the behavioural modelling based on a Mealy state machine. The following states are included to implement the 8 bit SAR in 10 clock cycles.

  01. s_init: Starting State. Clears the 'Done' bit and sets the DAC register to the default value ob b'10000000'.
  02. s_7: determines the 7th bit
  03. s_6: determines the 6th bit
  04. s_5: determines the 5th bit
  05. s_4: determines the 4th bit
  06. s_3: determines the 3rd bit
  07. s_2: determines the 2nd bit
  08. s_1: determines the 1st bit
  09. s_0: determines the 0th bit
  10. s_done: sets the 'Done' bit and updates the result register with the new result and clears the DAC register.

Simulataneous processes are used to simulate the operation of the SAR in the test bench. The error reporting process uses assert and report statements as well as the textfile outputs to report to the live simulator console and record the outputs for off-line analysis respectively.

The test bench is designed following the steps described in the README of https://github.com/prabhathb/Four_input_AND_gate. Snap shots of the test results are also provided.

Test benched was simulated on ModelSim starter edition 2020.1 by Mentor Graphics.
