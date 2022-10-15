# Audio Frequency Based Stepper Motor Driver on ARM
- 1 Khz Microphone Capture and Digital Signal Processing
- Control LED Color According to Sound Frequency
- Frequency Thresholds can be set by Serial UI and KeyPad
- Stepper Motor Speed according to Magnitude of the Sound
- Stepper Motor Direction is according to on-board switch

# Project Features
- Controller : EK-TM4C123GXL (TM4C123GH6PM)
- Language	 : Assembly ARM Thumb2 
- IDE 		 : Keil uVision Project
- LCD Screen Handling (Nokia 5110)
- UART 38400 8N1 (Serial UI)
- SPI
- KeyPad Handling with Debouncing
- Switch Handling with Debouncing
- Stepper Motor Handling
- ADC 2 KHz Microphone
- ADC Potentiometer
- CMSIS DSP Implementation
- Customizable Font Types for LCD Screen

# Modules

## ADC0
- SS0: Potentiometer, One-Shot, Interrupt Enabled, Pin AIN1 (E2), Priority 2
- SS3: Microphone	, One-Shot, Interrupt Enabled, Pin AIN0 (E3), Priority 1

## Timer0
- Timer0A: Motor Driving, 4 MHz Clock, One-shot, Counting Down, Timeout Interrupt Enabled, Priority 2, Slow Reload Value.

## SysTick
- Generating 2 kHz Sampling Rate for ADC0SS3 and Enabling 1-Sec Update Routine. Enable Interrupt, Priority 1. 

## SSI3 SPI
- 4 MHz CLK, 8-bit Frame, FreeScale Mode.

 
# System Overview
<p align="center">
	<picture>
		<source media="(prefers-color-scheme: dark)" srcset="https://AtaberkOKLU.github.io/Audio-Frequency-Based-Stepper-Motor-Driver-on-ARM/Docs/System.drawio_dark.png">
		<source media="(prefers-color-scheme: light)" srcset="https://AtaberkOKLU.github.io/Audio-Frequency-Based-Stepper-Motor-Driver-on-ARM/Docs/System.drawio.png">
		<img alt="System Overview" src="https://AtaberkOKLU.github.io/Audio-Frequency-Based-Stepper-Motor-Driver-on-ARM/Docs/System.drawio.png">
	</picture>
</p>

# Summarized FlowCharts
<p align="center">
	<picture>
		<source media="(prefers-color-scheme: dark)" srcset="https://AtaberkOKLU.github.io/Audio-Frequency-Based-Stepper-Motor-Driver-on-ARM/Docs/FlowChart.drawio_dark.png">
		<source media="(prefers-color-scheme: light)" srcset="https://AtaberkOKLU.github.io/Audio-Frequency-Based-Stepper-Motor-Driver-on-ARM/Docs/FlowChart.drawio.png">
		<img alt="FlowCharts" src="https://AtaberkOKLU.github.io/Audio-Frequency-Based-Stepper-Motor-Driver-on-ARM/Docs/FlowChart.drawio.png">
	</picture>
</p>

# Project Requirement
See [Project Definition PDF](https://AtaberkOKLU.github.io/Audio-Frequency-Based-Stepper-Motor-Driver-on-ARM/Docs/EE447_Project.pdf)

# Project Report
See [Project Report PDF](https://AtaberkOKLU.github.io/Audio-Frequency-Based-Stepper-Motor-Driver-on-ARM/Docs/TermProjectReport.pdf)


