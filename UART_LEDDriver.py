import serial

OK_RESPONSE = "ok "

class UART_LEDDriver:

    def __init__(self, TheUARTPort, TheBaudRate, TheTimeout, TheVerboseOutput):

        self.UARTPort = TheUARTPort
        self.BaudRate = TheBaudRate
        self.Timeout = TheTimeout
        self.VerboseOutput = TheVerboseOutput
        
        try:
            self.ser = serial.Serial(self.UARTPort, self.BaudRate, timeout=self.Timeout)
            self.WriteCommand("")
            self.WriteCommand("init()")
            self.ClassInit = True
            
        #endtry
        except:
            raise ValueError("FATAL Error: Unable to initialising the UART module [%s], exiting" % self.UARTPort)
            self.ClassInit = False
        #endexcept

        return
    #enddef

    def NoVerboseOutput(self, TheValue):
        self.VerboseOutput = TheValue
    #enddef
    
    def WriteCommand(self, TheCommand):
        try:
            line = TheCommand + "\n"
            self.ser.write(line)
    
            line= ""
            while line <> OK_RESPONSE:
                line = self.ser.readline()
                line = line.strip('\n')
                line = line.strip('\r')
                if line <> "":
                    if line <> OK_RESPONSE:
                        if self.VerboseOutput == True:
                            print("UART_LEDDriver: %s" % line)
                        #endif
                    #endif                    
                #endif
            #endwhile
        except:
            raise ValueError("FATAL Error: Error reading/writing to UART module [%s], exiting" % self.UARTPort)

        
        return
    #enddef

    def ResetBuffer(self):
        TheLine = "AddItemToDataArray(START, 0)"
        self.WriteCommand(TheLine)
    #enddef        

    def PrintMessage(self, TheMessage):        
        for c in TheMessage:
            TheLine = "AddItemToDataArray(CHARACTER," + str(ord(c)) + ")"
            self.WriteCommand(TheLine)
        #endfor
        return
    #endef

    def PrintBitmapArray(self, TheArray):
        for b in TheArray:
            TheLine = "AddItemToDataArray(BITMAP," + str(b) + ")"
            self.WriteCommand(TheLine)
        #endfor
        return        

    #enddef

    def StartDisplayScroll(self, TheNumberOfTimes):
        TheLine = "ScrollDataArray(" + str(TheNumberOfTimes) + ", BOTH)"
        self.WriteCommand(TheLine)
        return
    #enddef

    def CLS(self):
        TheLine = "CLS(BOARD0)"
        self.WriteCommand(TheLine)

        TheLine = "CLS(BOARD1)"
        self.WriteCommand(TheLine)
    #enddef        

    def __del__(self):
        if self.ClassInit == True:
            self.CLS()
            self.ser.close()
        #endif
        return
    #enddef
#endclass
