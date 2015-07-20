from UART_LEDDriver import UART_LEDDriver
from sys import platform as _platform

TrainBitmap = [48,120,255,255,120,126,98,99,227,226,126,64]
CarriageBitmap = [112,254,242,114,114,126,114,114,242,254,112,64]
WhitespaceBitmap = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
SpaceBitmap = [0,0,0,0,0,0,0,0]

def main():

    try:

        if _platform == "linux" or _platform == "linux2":
            PortName = '/dev/ttyUSB0'
        elif _platform == "win32":
            PortName = 'COM3'
        #endif

        print("Setting UARTPort to %s" % PortName)

        # UART_LEDDriver(UARTPort, BaudRate, Timeout(sec), VerboseOutput(True|False)
        LEDsign = UART_LEDDriver(PortName, 115200, 0.001, True)

        # reset the buffer, purge all previous data
        LEDsign.ResetBuffer()

        # Add Whitespace bitmap
        LEDsign.PrintBitmapArray(WhitespaceBitmap)
        LEDsign.PrintBitmapArray(WhitespaceBitmap)

        # Add a text message
        LEDsign.PrintMessage("Welcome to Barnwood Model Railway Club")
        LEDsign.PrintBitmapArray(SpaceBitmap)

        # Add the Train bitmap
        LEDsign.PrintBitmapArray(TrainBitmap)

        # Add three Carriage bitmaps
        LEDsign.PrintBitmapArray(CarriageBitmap)
        LEDsign.PrintBitmapArray(CarriageBitmap)
        LEDsign.PrintBitmapArray(CarriageBitmap)

        # Add Whitespace bitmapp
        LEDsign.PrintBitmapArray(WhitespaceBitmap)
        LEDsign.PrintBitmapArray(WhitespaceBitmap)

        # Append a text message
        LEDsign.PrintMessage("www.barnwoodmodelrailwayclub.org.uk")

        # Scroll the Display buffer twice
        LEDsign.StartDisplayScroll(999)

    except:
        print("\nException caught, exiting....\n")
        exit()
    #endexcept

    return

#enddef

#===============================================================================
# Set the entry point for the application
#===============================================================================
if __name__ == '__main__':
    main()
    exit()
    quit()

#EOF
