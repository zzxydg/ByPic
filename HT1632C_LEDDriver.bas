// Constants for LED commands
constant COMMAND 0x8000
constant DATA 0xA000
constant SYS_DIS 0x00
constant SYS_EN 0x01
constant LED_OFF 0x02
constant LED_ON 0x03
constant BLINK_OFF 0x08
constant BLINK_ON 0x09
constant SLAVE_MODE 0x10
constant RC_MASTER_MODE 0x18
constant EXT_CLK_MASTER_MODE 0x1C
constant COMMON_8NMOS 0x20
constant PWM16 0xAF

constant BOARD0 0x00
constant BOARD1 0x01
constant BOTH 0x03

constant START 0x01
constant CHARACTER 0x02
constant BITMAP 0x04

constant MAX_BUFFER_SIZE 1024
constant DISPLAY_LENGTH 32
constant DISPLAY_HEIGHT 8

dim me_ThePort
dim me_TheWRPin
dim me_TheDataPin
dim me_TheCS0Pin
dim me_TheCS1Pin

//# The DisplayBuffer
dim me_DisplayBuffer(MAX_BUFFER_SIZE)
dim me_BufferSize

constant TheMask {0x01, 0x02, 0x04, 0x08, 0x10, 0x20, 0x40, 0x80}

//# The Font bitmap
constant TerminalFont { \
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00 \
    0x00, 0x06, 0x5F, 0x06, 0x00, 0x00 \
    0x07, 0x03, 0x00, 0x07, 0x03, 0x00 \
    0x24, 0x7E, 0x24, 0x7E, 0x24, 0x00 \
    0x24, 0x2B, 0x6A, 0x12, 0x00, 0x00 \
    0x63, 0x13, 0x08, 0x64, 0x63, 0x00 \
    0x36, 0x49, 0x56, 0x20, 0x50, 0x00 \
    0x00, 0x07, 0x03, 0x00, 0x00, 0x00 \
    0x00, 0x3E, 0x41, 0x00, 0x00, 0x00 \
    0x00, 0x41, 0x3E, 0x00, 0x00, 0x00 \
    0x08, 0x3E, 0x1C, 0x3E, 0x08, 0x00 \
    0x08, 0x08, 0x3E, 0x08, 0x08, 0x00 \
    0x00, 0xE0, 0x60, 0x00, 0x00, 0x00 \
    0x08, 0x08, 0x08, 0x08, 0x08, 0x00 \
    0x00, 0x60, 0x60, 0x00, 0x00, 0x00 \
    0x20, 0x10, 0x08, 0x04, 0x02, 0x00 \
    0x3E, 0x51, 0x49, 0x45, 0x3E, 0x00 \
    0x00, 0x42, 0x7F, 0x40, 0x00, 0x00 \
    0x62, 0x51, 0x49, 0x49, 0x46, 0x00 \
    0x22, 0x49, 0x49, 0x49, 0x36, 0x00 \
    0x18, 0x14, 0x12, 0x7F, 0x10, 0x00 \
    0x2F, 0x49, 0x49, 0x49, 0x31, 0x00 \
    0x3C, 0x4A, 0x49, 0x49, 0x30, 0x00 \
    0x01, 0x71, 0x09, 0x05, 0x03, 0x00 \
    0x36, 0x49, 0x49, 0x49, 0x36, 0x00 \
    0x06, 0x49, 0x49, 0x29, 0x1E, 0x00 \
    0x00, 0x6C, 0x6C, 0x00, 0x00, 0x00 \
    0x00, 0xEC, 0x6C, 0x00, 0x00, 0x00 \
    0x08, 0x14, 0x22, 0x41, 0x00, 0x00 \
    0x24, 0x24, 0x24, 0x24, 0x24, 0x00 \
    0x00, 0x41, 0x22, 0x14, 0x08, 0x00 \
    0x02, 0x01, 0x59, 0x09, 0x06, 0x00 \
    0x3E, 0x41, 0x5D, 0x55, 0x1E, 0x00 \
    0x7E, 0x11, 0x11, 0x11, 0x7E, 0x00 \
    0x7F, 0x49, 0x49, 0x49, 0x36, 0x00 \
    0x3E, 0x41, 0x41, 0x41, 0x22, 0x00 \
    0x7F, 0x41, 0x41, 0x41, 0x3E, 0x00 \
    0x7F, 0x49, 0x49, 0x49, 0x41, 0x00 \
    0x7F, 0x09, 0x09, 0x09, 0x01, 0x00 \
    0x3E, 0x41, 0x49, 0x49, 0x7A, 0x00 \
    0x7F, 0x08, 0x08, 0x08, 0x7F, 0x00 \
    0x00, 0x41, 0x7F, 0x41, 0x00, 0x00 \
    0x30, 0x40, 0x40, 0x40, 0x3F, 0x00 \
    0x7F, 0x08, 0x14, 0x22, 0x41, 0x00 \
    0x7F, 0x40, 0x40, 0x40, 0x40, 0x00 \
    0x7F, 0x02, 0x04, 0x02, 0x7F, 0x00 \
    0x7F, 0x02, 0x04, 0x08, 0x7F, 0x00 \
    0x3E, 0x41, 0x41, 0x41, 0x3E, 0x00 \
    0x7F, 0x09, 0x09, 0x09, 0x06, 0x00 \
    0x3E, 0x41, 0x51, 0x21, 0x5E, 0x00 \
    0x7F, 0x09, 0x09, 0x19, 0x66, 0x00 \
    0x26, 0x49, 0x49, 0x49, 0x32, 0x00 \
    0x01, 0x01, 0x7F, 0x01, 0x01, 0x00 \
    0x3F, 0x40, 0x40, 0x40, 0x3F, 0x00 \
    0x1F, 0x20, 0x40, 0x20, 0x1F, 0x00 \
    0x3F, 0x40, 0x3C, 0x40, 0x3F, 0x00 \
    0x63, 0x14, 0x08, 0x14, 0x63, 0x00 \
    0x07, 0x08, 0x70, 0x08, 0x07, 0x00 \
    0x71, 0x49, 0x45, 0x43, 0x00, 0x00 \
    0x00, 0x7F, 0x41, 0x41, 0x00, 0x00 \
    0x02, 0x04, 0x08, 0x10, 0x20, 0x00 \
    0x00, 0x41, 0x41, 0x7F, 0x00, 0x00 \
    0x04, 0x02, 0x01, 0x02, 0x04, 0x00 \
    0x80, 0x80, 0x80, 0x80, 0x80, 0x00 \
    0x00, 0x03, 0x07, 0x00, 0x00, 0x00 \
    0x20, 0x54, 0x54, 0x54, 0x78, 0x00 \
    0x7F, 0x44, 0x44, 0x44, 0x38, 0x00 \
    0x38, 0x44, 0x44, 0x44, 0x28, 0x00 \
    0x38, 0x44, 0x44, 0x44, 0x7F, 0x00 \
    0x38, 0x54, 0x54, 0x54, 0x08, 0x00 \
    0x08, 0x7E, 0x09, 0x09, 0x00, 0x00 \
    0x18, 0xA4, 0xA4, 0xA4, 0x7C, 0x00 \
    0x7F, 0x04, 0x04, 0x78, 0x00, 0x00 \
    0x00, 0x00, 0x7D, 0x40, 0x00, 0x00 \
    0x40, 0x80, 0x84, 0x7D, 0x00, 0x00 \
    0x7F, 0x10, 0x28, 0x44, 0x00, 0x00 \
    0x00, 0x00, 0x7F, 0x40, 0x00, 0x00 \
    0x7C, 0x04, 0x18, 0x04, 0x78, 0x00 \
    0x7C, 0x04, 0x04, 0x78, 0x00, 0x00 \
    0x38, 0x44, 0x44, 0x44, 0x38, 0x00 \
    0xFC, 0x44, 0x44, 0x44, 0x38, 0x00 \
    0x38, 0x44, 0x44, 0x44, 0xFC, 0x00 \
    0x44, 0x78, 0x44, 0x04, 0x08, 0x00 \
    0x08, 0x54, 0x54, 0x54, 0x20, 0x00 \
    0x04, 0x3E, 0x44, 0x24, 0x00, 0x00 \
    0x3C, 0x40, 0x20, 0x7C, 0x00, 0x00 \
    0x1C, 0x20, 0x40, 0x20, 0x1C, 0x00 \
    0x3C, 0x60, 0x30, 0x60, 0x3C, 0x00 \
    0x6C, 0x10, 0x10, 0x6C, 0x00, 0x00 \
    0x9C, 0xA0, 0x60, 0x3C, 0x00, 0x00 \
    0x64, 0x54, 0x54, 0x4C, 0x00, 0x00 \
    0x08, 0x3E, 0x41, 0x41, 0x00, 0x00 \
    0x00, 0x00, 0x77, 0x00, 0x00, 0x00 \
    0x00, 0x41, 0x41, 0x3E, 0x08, 0x00 \
    0x02, 0x01, 0x02, 0x01, 0x00, 0x00 \
    0x3C, 0x26, 0x23, 0x26, 0x3C, 0x00 }

//# --------------------------------------------------------------------------------------------
//# Name: sendbit
//# Description: The code pushes our the Bit to the DATA line
//# This code uses "bitbanging" so is supper quick but makes some assumptions around data ordering
//#
//# Inputs:
//# TheBit - The bit (HIGH or LOW) to output onto the DATA line, pulsing the WR pin
//#
//# Method:
//# Pushes out the bit using "bitbanging" to the DATA line
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function sendbit(TheBit)
    io_write(me_ThePort, me_TheDataPin, TheBit) // # Send the bit
    io_write(me_ThePort, me_TheWRPin, LOW) 		// # WR low to clock into the device
    io_write(me_ThePort, me_TheWRPin, HIGH)		// # WR high to end the write cycle
endf

//# --------------------------------------------------------------------------------------------
//# Name: StreamOutDataArray
//# Description: The code pushes our the DisplayBuffer starting as the specified offset
//# This code uses "bitbanging" so ir supper quick but makes some assumptions around data ordering
//#
//# Inputs:
//# StartPos - The posotion to start the write from
//# TheCSPin - The Display to buffer out to defined by the CS pin
//#
//# Method:
//# Loops through the data array for the length specified and pushes out the
//# data the quick way to the LED module
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function StreamOutDataArray(StartPos, TheCSPin)
    dim i, j

	io_write(me_ThePort, me_TheWRPin, HIGH)		//# WR high to start the write cycle
	io_write(me_ThePort, TheCSPin, LOW)			//# Pull CS Low to start cycle

    // Send Command bit (DATA)
    sendbit(HIGH)   // C0
    sendbit(LOW)    // C1
    sendbit(HIGH)   // C2

    // Send Address Bits (all zero)
    sendbit(LOW) //A0
    sendbit(LOW) //A1
    sendbit(LOW) //A2
    sendbit(LOW) //A3
    sendbit(LOW) //A4
    sendbit(LOW) //A5
    sendbit(LOW) //A6

    for i = StartPos to (StartPos+DISPLAY_LENGTH-1)
        for j = 0 to DISPLAY_HEIGHT-1

            if me_DisplayBuffer(i) & TheMask(j) then
                io_write(me_ThePort, me_TheDataPin, HIGH)   // # Send the bit [HIGH]
            else
                io_write(me_ThePort, me_TheDataPin, LOW)    // # Send the bit [LOW]
            endif

            io_write(me_ThePort, me_TheWRPin, LOW) 		// # WR low to clock into the device
            io_write(me_ThePort, me_TheWRPin, HIGH)		// # WR high to end the write cycle

        next
    next

    io_write(me_ThePort, TheCSPin, HIGH)            	// # Pull CS High to finish cycle

endf

//# --------------------------------------------------------------------------------------------
//# Name: GenerateDataArrayFromString
//# Description: Generate a font bitmap for the supplied string
//#
//# Inputs:
//# TheString - The null termindated string to generate a bitmap for
//#
//# Method:
//# Loops through the characters in the string and generates the font bitmap
//# and copies into the DisplayBuffer for display ir scroll
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function GenerateDataArrayFromString(TheString$[256])
    dim ArrayIndex, i, cPos, cValue, LookupIndex

    // Clear out the old data
    for i=0 to MAX_BUFFER_SIZE-1
        me_DisplayBuffer(i) = 0x00
    next

    me_BufferSize = 0
    ArrayIndex = 0

    // Lookup the font bitmap for the character and load
    for cPos = 0 to strlen(TheString$) - 1
        cValue = asc(TheString$, cPos)
        LookupIndex = (cValue - 32) * 6
        for i=0 to 5
            me_DisplayBuffer(ArrayIndex + i) = TerminalFont(LookupIndex + i)
        next
        ArrayIndex = ArrayIndex + 6
    next
    me_BufferSize = ArrayIndex
endf

function AddItemToDataArray(TheCommand, TheItem)
    dim i, LookupIndex

    // Clear out the old data
    if TheCommand = START then
        for i=0 to MAX_BUFFER_SIZE-1
            me_DisplayBuffer(i) = 0x00
        next
        me_BufferSize = 0
        print "AddItemToDataArray(): buffer reset\n"
    endif

    // Add a character from the TerminalFont
    if TheCommand = CHARACTER then

        if ((me_BufferSize + 6) < MAX_BUFFER_SIZE) then
            LookupIndex = (TheItem - 32) * 6
            for i=0 to 5
                me_DisplayBuffer(me_BufferSize + i) = TerminalFont(LookupIndex + i)
            next
            me_BufferSize = me_BufferSize + 6
            print "AddItemToDataArray(): 6 items added\n"
        else
            print "AddItemToDataArray(): ERROR BUFFER FULL!"
        endif
    endif

    // Add a direct Bitmap
    if TheCommand = BITMAP then
        if ((me_BufferSize+1) < MAX_BUFFER_SIZE) then
            me_DisplayBuffer(me_BufferSize) = TheItem
            me_BufferSize = me_BufferSize + 1
            print "AddItemToDataArray(): 1 items added\n"
        else
            print "AddItemToDataArray(): ERROR BUFFER FULL!"
        endif
    endif

endf

//# --------------------------------------------------------------------------------------------
//# Name: ScrollDataArray
//# Description: Scrolls the contents of the data array the number of time specified
//#
//# Inputs:
//# NumberofLoops - The number of time to loop the DisplayBuffer
//#
//# Method:
//# Loops through the DisplayBuffer and writes it out to the display offsetting by
//# one to perfrom the scroll
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function ScrollDataArray(NumberofLoops, WhichDisplay)
    dim i, j, k

    print "ScrollDataArray(): me_BufferSize "
    print (me_BufferSize-1), MAX_BUFFER_SIZE
    print "\n"

    k = (NumberofLoops-1)

    if WhichDisplay = BOARD0 then
        for j=0 to k
            print "ScrollDataArray(): BOARD0 loop "
            print j, k
            print "\n"
            for i=0 to (me_BufferSize-1)
                StreamOutDataArray(i, me_TheCS0Pin)
            next
        next
    endif

    if WhichDisplay = BOARD1 then
        for j=0 to k
            print "ScrollDataArray(): BOARD1 loop "
            print j, k
            print "\n"
            for i=0 to (me_BufferSize-1)
                StreamOutDataArray(i, me_TheCS1Pin)
            next
        next
    endif

    if WhichDisplay = BOTH then
        for j=0 to k
            print "ScrollDataArray(): BOTH loop "
            print j, k
            print "\n"
            for i=0 to (me_BufferSize - 1)
                StreamOutDataArray(i, me_TheCS0Pin)
                StreamOutDataArray((i + DISPLAY_LENGTH), me_TheCS1Pin)
            next
        next
    endif

endf

//# --------------------------------------------------------------------------------------------
//# Name: WriteTheWord
//# Description: Writes out a 18, 14 or 12 bit word to the LED Matrix
//#
//# Inputs:
//# TheWord - The word to write to the LED Matrix (integer, 16 bits only, unused bits set to zero)
//# BitsToWrite - The length of the word to write to the Matrix.
//# 18 bits for a full column: 3 ID + 7 ADDRESS + 8 DATA
//# 14 bits for a half column: 3 ID + 7 ADDRESS + 4 DATA
//# 12 bits for a command    : 3 ID + 8 COMMAND + BLANK
//# TheCSPin - The CS pin to use for writing to the HT1632C, allows multiple boards to be used
//#
//# Method:
//# Writes out the bits directly to the LED Matrix using the CS, WR and DATA lines
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function WriteTheWord(TheWord, BitsToWrite, TheCSPin)
	dim Start, Stop, i, TheMask, TheTest

	io_write(me_ThePort, me_TheWRPin, HIGH)		//# WR high to start the write cycle
	io_write(me_ThePort, TheCSPin, LOW)			//# Pull CS Low to start cycle

	//# Command is 12 bits; NibbleData is 14 bits; ByteData is 18 bits -- we are bit banging so
	//# only output what is needed, as it is faster!

    select(BitsToWrite)
        case(18)
            Start=17
            Stop=0
            break
        case(14)
            Start=15
            Stop=1
            break
        case(12)
            Start=15
            Stop=3
            break
    endselect

    for i=Start to Stop step -1							    //# MSB has to go first, LSB last so do it in reverse order

        TheMask = 0x1 << i                                  //# Generate the bit mask

        TheTest = TheWord & TheMask

        if TheTest = TheMask then
            io_write(me_ThePort, me_TheDataPin, HIGH)   	// # Send the bit
        else
            io_write(me_ThePort, me_TheDataPin, LOW)   	    // # Send the bit
        endif

        io_write(me_ThePort, me_TheWRPin, LOW) 		// # WR low to clock into the device
        io_write(me_ThePort, me_TheWRPin, HIGH)		// # WR high to end the write cycle
    next

    io_write(me_ThePort, TheCSPin, HIGH)            	// # Pull CS High to finish cycle
endf

//# --------------------------------------------------------------------------------------------
//# Name: WriteDataByte
//# Description: Writes out a full column of data to the Matrix, forming the correct word
//#
//# Inputs:
//# TheAddress - The address to write the nibble to [0..127] values outside of this range are
//# ignored, because a full column is written the address must be even, odd addresses will cause
//# only half the word to be shown in the column, with the other half in the next column
//#
//# Method:
//# Uses the WriteTheWord() send the command to the LED Matrix
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function WriteDataByte(TheAddress, TheDataByte)
    dim TheWord

	if TheAddress >= 0 then
        if TheAddress <= 0x3F then
            TheWord = (DATA << 2) | ((TheAddress & 0x3F) << 8) | (TheDataByte & 0xFF)
            WriteTheWord(TheWord, 18, me_TheCS0Pin)
            return
        endif
	endif

	if TheAddress >= 0x40 then
        if TheAddress <= 0x7F then
            TheWord = (DATA << 2) | ((TheAddress & 0x3F) << 8) | (TheDataByte & 0xFF)
            WriteTheWord(TheWord, 18, me_TheCS1Pin)
            return
        endif
	endif
endf

//# --------------------------------------------------------------------------------------------
//# Name: WriteCommand
//# Description: Writes out a single command to the LED Matrix, forming the correct word pattern
//#
//# Inputs:
//# TheCommand - The command code to send to the LED Matrix
//# TheBoard - The board to write to (BOARD0 or BOARD1)
//#
//# Method:
//# Uses the WriteTheWord() to send the command to the LED Matrix
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function WriteCommand(TheCommand, TheBoard)
	dim TheWord

    TheWord = COMMAND | (TheCommand << 5)

    if TheBoard = BOARD0 then
		WriteTheWord(TheWord, 12, me_TheCS0Pin)
        return
	endif

    if TheBoard = BOARD1 then
		WriteTheWord(TheWord, 12, me_TheCS1Pin)
        return
	endif
endf

//# --------------------------------------------------------------------------------------------
//# Name: WriteDataNibble
//# Description: Writes out half a column of data to the Matrix, forming the correct word
//#
//# Inputs:
//# TheAddress - The address to write the nibble to [0..127] values outside of this range are
//# ignored
//#
//# Method:
//# Uses the WriteTheWord() to send the command to the LED Matrix
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function WriteDataNibble(TheAddress, TheDataNibble)
	dim TheWord

    if TheAddress >= 0 then
        if TheAddress <= 0x3F then
            TheWord = DATA | ((TheAddress & 0x3F) << 6) | ((TheDataNibble & 0x0F) << 2)
            WriteTheWord(TheWord, 14, me_TheCS0Pin)
            return
        endif
	endif

    if TheAddress >= 0x40 then
        if TheAddress <= 0xFF then
            TheWord = DATA | ((TheAddress & 0x3F) << 6) | ((TheDataNibble & 0x0F) << 2)
            WriteTheWord(TheWord, 14, me_TheCS1Pin)
            return
        endif
	endif
endf

//# --------------------------------------------------------------------------------------------
//# Name: InitTheBoard
//# Description: The initialization code for the LED Matrix
//#
//# Inputs:
//# TheBoard = The HT1632C to initi (BOARD0 or BOARD1)
//#
//# Method:
//# Sets up the HT1632C LED Matrix, sequence and codes taken from the Datasheet and Arduino
//# example https://github.com/gauravmm/HT1632-for-Arduino
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function InitTheBoard(TheBoard)
    WriteCommand(SYS_DIS, TheBoard)
    WriteCommand(COMMON_8NMOS, TheBoard)
    WriteCommand(SYS_EN, TheBoard)
    WriteCommand(LED_ON, TheBoard)
    WriteCommand(PWM16, TheBoard)
    wait(100)                     // # Might not be needed, but works!
endf

//# --------------------------------------------------------------------------------------------
//# Name: InitHT1632CDisplay
//# Description: The initialization code for the LED module
//#
//# Inputs:
//# TheWRPin - The IO line the HT1632C (Board0 & Board1) WR line is connected to
//# TheDataPin - The  IO line the HT1632C (Board0 & Board1) DATA line is connected to
//# TheCS0Pin - The  IO line the HT1632C (Board0) CS line is connected to, 0 if not used
//# TheCS1Pin - The  IO line the HT1632C (Board1) CS line is connected to, 0 if not used
//#
//# Method:
//# Sets up the direction of the IO pins then initialises the HT1632C
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function InitHT1632CDisplay(ThePort, TheWRPin, TheDataPin, TheCS0Pin, TheCS1Pin)

    me_ThePort = ThePort
    me_TheWRPin = TheWRPin
    me_TheDataPin = TheDataPin
    me_TheCS0Pin = TheCS0Pin
    me_TheCS1Pin = TheCS1Pin

    //# Setup the IO lines
	io_pinMode(me_ThePort, me_TheWRPin ,OUT, WOFF)
	io_pinMode(me_ThePort, me_TheDataPin ,OUT, WOFF)

    if me_TheCS0Pin <> 0
		io_pinMode(me_ThePort, me_TheCS0Pin ,OUT, WOFF)
		io_write(me_ThePort, me_TheCS0Pin, HIGH)
        InitTheBoard(BOARD0)
        print "InitHT1632CDisplay(): BOARD0\n"
    endif

    if me_TheCS1Pin <> 0
		io_pinMode(me_ThePort, me_TheCS1Pin ,OUT, WOFF)
		io_write(me_ThePort, me_TheCS1Pin, HIGH)
        InitTheBoard(BOARD1)
        print "InitHT1632CDisplay(): BOARD1\n"
    endif

endf

//# --------------------------------------------------------------------------------------------
//# Name: ALL
//# Description: Does a quick test by switching all LEDs on
//#
//# Inputs:
//# TheBoard -- The Board to use (BOARD0 or BOARD1)
//#
//# Method:
//# Writes random to all addresses to switch on some LEDs
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function ALLON(TheBoard)
    dim i, j, TheCSPin

    if TheBoard = BOARD0
        TheCSPin = me_TheCS0Pin
    else
        TheCSPin = me_TheCS1Pin
    endif

    for i=0 to DISPLAY_LENGTH-1
        me_DisplayBuffer(i) = 0xFF
    next

    StreamOutDataArray(0, TheCSPin)

endf

//# --------------------------------------------------------------------------------------------
//# Name: CLS
//# Description: Clears (switches off) all the LEDs on the Matrix
//#
//# Inputs:
//# TheBoard -- The Board to use (BOARD0 or BOARD1)
//#
//# Method:
//# Writes out 0x00 to all addresses to switch off any LEDs that are on
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function CLS(TheBoard)
    dim i, TheCSPin

    if TheBoard = BOARD0
        TheCSPin = me_TheCS0Pin
    else
        TheCSPin = me_TheCS1Pin
    endif

    for i=0 to DISPLAY_LENGTH-1
        me_DisplayBuffer(i) = 0x00
    next
    StreamOutDataArray(0, TheCSPin)
endf

//# --------------------------------------------------------------------------------------------
//# Name: FLASH
//# Description: Does a quick test by flashing all LEDs
//#
//# Inputs:
//# TheBoard -- The Board to use (BOARD0 or BOARD1)
//# TimesToFlash -- The number of times to flash LEDs
//#
//# Method:
//# Writes random to all addresses to switch on some LEDs
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function FLASH(TheBoard, TimesToFlash)
    dim i

    for i = 0 to TimesToFlash-1
        ALLON(TheBoard)
        CLS(TheBoard)
    next
endf

//# --------------------------------------------------------------------------------------------
//# Name: POST
//# Description: Does a quick Power On Self Test by switching on all LEDs then off again
//#
//# Inputs:
//# TheBoard -- The Board to user (BOARD0 or BOARD1)
//#
//# Method:
//# Writes 0xFF to all addresses to switch on all LED, then writes 0x00 to switch all off
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function POST()
    print "POST()\n"
    ALLON(BOARD0)
    ALLON(BOARD1)
    wait(250)
    CLS(BOARD0)
    CLS(BOARD1)
endf

//# --------------------------------------------------------------------------------------------
//# Name: RANDOM
//# Description: Does a quick test by randomly lighing the LEDs
//#
//# Inputs:
//# TheCSPin -- The Diasplay to use, indicated by CS pin
//# NumberOfTimes -- Number of time to full the display with random
//#
//# Method:
//# Writes random to all addresses to switch on some LEDs
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function RANDOM(TheBoard, NumberOfTimes)
    dim i, j, TheCSPin

    if TheBoard = BOARD0
        TheCSPin = me_TheCS0Pin
    else
        TheCSPin = me_TheCS1Pin
    endif

    for j = 0 to NumberOfTimes-1
        for i=0 to DISPLAY_LENGTH-1
            me_DisplayBuffer(i) = rand(0x00, 0xFF)
        next
        StreamOutDataArray(0, TheCSPin)
    next
endf

//# --------------------------------------------------------------------------------------------
//# Name: PresetMessage
//# Description: Displays a preset message on the screen for the number of times specified
//#
//# Inputs:
//# TheMessage -- The Message number to display
//# NumberOfTimes -- Number of time to display the message
//#
//# Method:
//# Uses GenerateDataArrayFromString() and ScrollDataArray() to display the message
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function PresetMessage(TheMessage, NumberOfTimes, WhichDisplay)

    select(TheMessage)
        case(1)
            GenerateDataArrayFromString("HT1632C_LEDDriver.bas")
            ScrollDataArray(NumberOfTimes, WhichDisplay)
            break
        case(2)
            GenerateDataArrayFromString("The quick brown fox jumps over the lazy dog!")
            ScrollDataArray(NumberOfTimes, WhichDisplay)
            break
        case(3)
            GenerateDataArrayFromString("#Insert custom text here#")
            ScrollDataArray(1, WhichDisplay)
            break
    endselect

endf

//# --------------------------------------------------------------------------------------------
//# Name: init
//# Description: The initialization code for the LED module using pre-defined pins
//#
//# Inputs: None
//#
//# Method:
//# Invokes InitHT1632CDisplay with pre-defined arguments to setup the modules
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
function init()
	InitHT1632CDisplay(PORTB, 14, 15, 13, 12)
    POST()
endf

function pulse()

    io_pinMode(PORTB, 15 ,OUT, WOFF)

    while(1)
        io_write(PORTB, 15, HIGH)
        io_write(PORTB, 15, LOW)
    wend
endf

//# --------------------------------------------------------------------------------------------
//# --------------------------------------------------------------------------------------------
//# Name: demo
//# Description: The entry point for the demo
//#
//# Inputs: None
//#
//# Method:
//# Performs demo
//#
//# Outputs: None
//# --------------------------------------------------------------------------------------------
//# --------------------------------------------------------------------------------------------
function demo()
    init()

    AddItemToDataArray(START, 0x00)
    AddItemToDataArray(CHARACTER, asc("Hello", 0))
    AddItemToDataArray(CHARACTER, asc("Hello", 1))
    AddItemToDataArray(CHARACTER, asc("Hello", 2))
    AddItemToDataArray(CHARACTER, asc("Hello", 3))
    AddItemToDataArray(CHARACTER, asc("Hello", 4))
    AddItemToDataArray(BITMAP, 0x00)
    AddItemToDataArray(BITMAP, 0x18)
    AddItemToDataArray(BITMAP, 0x18)
    AddItemToDataArray(BITMAP, 0x18)
    AddItemToDataArray(BITMAP, 0x18)
    AddItemToDataArray(BITMAP, 0xFF)
    AddItemToDataArray(BITMAP, 0x7E)
    AddItemToDataArray(BITMAP, 0x3C)
    AddItemToDataArray(BITMAP, 0x18)
    AddItemToDataArray(BITMAP, 0x00)
    AddItemToDataArray(CHARACTER, asc("World!", 0))
    AddItemToDataArray(CHARACTER, asc("World!", 1))
    AddItemToDataArray(CHARACTER, asc("World!", 2))
    AddItemToDataArray(CHARACTER, asc("World!", 3))
    AddItemToDataArray(CHARACTER, asc("World!", 4))
    AddItemToDataArray(CHARACTER, asc("World!", 5))

    ScrollDataArray(3, BOARD0)
    ScrollDataArray(3, BOARD1)
    ScrollDataArray(3, BOTH)

    wait(1000)
    CLS(BOARD0)
    CLS(BOARD1)

endf


// EOF
