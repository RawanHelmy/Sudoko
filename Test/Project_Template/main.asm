INCLUDE Irvine32.inc
BUFFER_SIZE = 97
.data
str1 Byte "Soduko !!! =))" , 0
str2 Byte "Enter 1  To start a new game " , 0
str3 Byte "Enter 2  To continue a saved borad " , 0
str4 Byte "Choose a Level : " , 0
str5 Byte "Enter 1 for Easy " , 0
Str6 Byte "Enter 2 for Meduim"  , 0
Str7 Byte "Enter 3 for Hard " , 0
str8 Byte "Choose a number : " , 0
str9 Byte "1.Change a cell   2.Clear the board    3.Save   4.Print the Finished Board ", 0
str10 Byte "Enter the row first then the column then value : " , 0
str11 Byte "The game has been saved !" , 0
str12 Byte "Number of correct answers : " , 0
str13 Byte "Number of missed : " , 0
str14 Byte "Time taken : ", 0
str15 Byte "Number of steps left : ",0
left Byte 0
Val Byte ?
Row Byte ?
Col Byte ?
StartTime Dword ?
EndTime Dword ?
min Dword ?
seconds Dword ?
ErrorMessage Byte "Wrong Cell" , 0
CorrectAnswer Byte"Got it Right !!" ,0
Ccount Byte 0
Wcount Byte 0
randBoardNumber DWORD ?
unsolved Byte BUFFER_SIZE DUP(?) ,0
solved Byte BUFFER_SIZE DUP(?) ,0
userunsolved Byte BUFFER_SIZE DUP(?) ,0
num dword ?
solvedBoard Byte "diff_1_1_solved.txt" , 0
FileName Byte "diff_1_1.txt" , 0
OutPut Byte "Output.txt", 0
fileHandle Handle ?
.code

;--------------------------------------------------------------------
;Gets the level from the user and fills the usolved buffer with it 
;--------------------------------------------------------------------

ReadRandomFile PROC level:DWORD 

       cmp level , 1  ; level 1   ; Easy level board number 1
       jne NotEqual
       cmp randBoardNumber , 0
       Jne NotOne
       JMP ReadBoard

       NotOne:
       cmp randBoardNumber , 1   ; Easy level board number 2
       jne NotTwo
       mov FileName[7] , '2' 
       mov solvedBoard[7] , '2' 
       JMP ReadBoard
       NotTwo:                   ;Easy level board number 3
       mov FileName[7] , '3' 
       mov solvedBoard[7] , '3' 
       JMP ReadBoard

       NotEqual:                  ;Meduim level
       cmp level , 2  ; level 2   ;Meduim level board number 1
       jne notEqualTwo
       cmp randBoardNumber , 0
       Jne NotOne2
       mov FileName[5] , '2' 
       mov solvedBoard[5] , '2' 
       JMP ReadBoard
       NotOne2:                   ;Meduim level board number 2
       cmp randBoardNumber , 1
       jne NotTwo2
       mov FileName[7] , '2' 
       mov solvedBoard[7] , '2' 
       mov FileName[5] , '2' 
       mov solvedBoard[5] , '2' 
       JMP ReadBoard 
       NotTwo2:                   ;Meduim level board number 3
       mov FileName[7] , '2' 
       mov solvedBoard[7] , '2' 
       mov FileName[5] , '2' 
       mov solvedBoard[5] , '2' 
       JMP ReadBoard

       notEqualTwo:                 ;Hard level
       cmp randBoardNumber , 0      ;Hard level board number 1
       Jne NotOne3
       mov FileName[5] , '3' 
       mov solvedBoard[5] , '3' 
       JMP ReadBoard
       NotOne3:                     ;Hard level board number 2
       cmp randBoardNumber , 1
       jne NotTwo3
       mov FileName[7] , '2' 
       mov solvedBoard[7] , '2' 
       mov FileName[5] , '3' 
       mov solvedBoard[5] , '3' 
       JMP ReadBoard
       NotTwo3:                       ;Hard level board number 3 
       mov FileName[7] , '3' 
       mov solvedBoard[7] , '3' 
       mov FileName[5] , '3' 
       mov solvedBoard[5] , '3' 

       ReadBoard :  ;Read the unsolved board

       mov edx,OFFSET Filename
       call OpenInputFile
       mov fileHandle,eax
                                                    ; Check for errors
       cmp eax,INVALID_HANDLE_VALUE                 ; error opening file?
       jne file_ok                                  ; no: skip
       jmp quit                                     ; and quit
       file_ok:
                                             ; Read the file into a buffer.
       mov edx, offset userunsolved
       mov ecx,BUFFER_SIZE
       call ReadFromFile
       jnc check_buffer_size                        ; error reading?

       call WriteWindowsMsg
       jmp close_file
       check_buffer_size:
       cmp eax,BUFFER_SIZE                          ; buffer large enough?
       jb buf_size_ok ; yes
       jmp quit                                     ; and quit
       buf_size_ok:
       mov userunsolved[eax],0                            ; insert null terminator
	   mov edx ,offset userunsolved
	   call writestring
       close_file:                            
       mov eax,fileHandle
       call CloseFile
       quit:
       RET

ReadRandomFile ENDP

Clear proc uses  eax  ecx ebx  edi

   Invoke ReadRandomFile , number
   Call ReadUnSolvedBoard
   Call Dash
   mov edi , offset userunsolved
   mov ecx , 3

   Final:
   push ecx
   mov ecx ,3

   Dis:
   push ecx 
   mov al, 15
   call SetTextColor
   mov al , '|'
   call writechar
   mov ecx , 3
   L2:
   mov al ,' '
   call writechar
   push ecx
   mov ecx , 3
   L1:
   mov bl ,[edi]
   cmp bl , '_'
   jne cll
   mov al, 10
   call SetTextColor
   JMP nott
   cll :
   mov al, 15
   call SetTextColor
   nott:
   mov al , bl 
   call writechar
   mov al ,' '
   call writechar
   inc edi
   Loop L1
   mov al, 15
   call SetTextColor
   mov al , '|'
   call writechar
   pop ecx 
   Loop L2
   call crlf
   pop ecx 
   add edi , 2
   Loop Dis
   call crlf
   pop ecx 
   Loop Final


ret
Clear endp


main PROC

      
      mov edx , offset str1
	  mov al , 15
	  Call SetTextColor

      Call WriteString 
      Call crlf

	  mov edx ,offset str2 
	  mov al , 15
	  Call SetTextColor
	  Call WriteString 
	  Call crlf

	  mov edx ,offset str3
	  Call WriteString 
	  Call crlf

	  Call ReadDec
	  cmp eax , 1
	  jne Saved
	  
	  mov edx ,offset str4
	  Call WriteString 
	  Call crlf

	  mov edx ,offset str5
	  Call WriteString 
	  Call crlf

	  mov edx ,offset str6
	  Call WriteString 
	  Call crlf

	  mov edx ,offset str7
	  Call WriteString 
	  Call crlf

	  Call ReadDec
	  mov number , eax 
	  Call RandomNumber
	  Invoke ReadRandomFile , number
	  Call ReadUnSolvedBoard
	  Call ReadSolvedBoard
	  
	  Call Dash
	  Call Display
	  invoke GetTickCount
	  mov StartTime , eax
	  Again:
	  mov al , 15
	  Call SetTextColor
	  mov edx ,offset str8
	  Call WriteString 
	  Call crlf

	  mov edx ,offset str9
	  Call WriteString 
	  Call crlf

	  Call ReadDec


	  cmp al , 1
	  jne NotCell
	  mov edx ,offset str10  ; edit a cell in the board
	  Call WriteString 
	  Call crlf
	  Call ReadDec
	  mov Row,al

	  Call ReadDec
	  mov Col,al

	  Call ReadChar
	  mov Val,al
	  Call WriteChar
	  Call crlf
	  Call Check
	  JMP Again
	  NotCell:    ; Clear the board
	  cmp al , 2
	  jne NotClear
	  Call Clear
	  Jmp Again
	  NotClear:
	  cmp al , 3
	  Jne NotSave
	  ;Call Save  ; save the board
	  mov edx ,offset str11
	  mov al , 9
	  Call SetTextColor
	  Call WriteString
	  Call Crlf
	  Jmp Quit
	  NotSave:
	  cmp al , 4
	  Jne Quit  ; view the answer and end the game
	  invoke GetTickCount
	  mov EndTime , eax
	  Call View
	  mov edx , offset str12
	  Call WriteString
	  mov eax ,0
	  mov al , Ccount
	  Call WriteDec
	  Call crlf
	  mov edx , offset str13
	  Call WriteString
	  mov al , Wcount
	  Call WriteDec
	  call crlf
	  mov edx , offset str15
	  call writestring 
	  mov al , left
	  call writedec
	  call crlf
	  mov edx , offset str14
	  Call writestring 
	  Call TimeFunction
	  Jmp Quit
	  Saved:


	  Quit:
	  mov al , 15
	  Call SetTextColor
	exit
main ENDP
;------------------------------------------
;Calculates time and displays it 
;-----------------------------------------
TimeFunction PROC uses edx 

    mov eax , EndTime
	sub eax , StartTime
	mov edx ,0
	mov ebx , 1000
	div ebx
	mov edx ,0
	mov ebx,60
	div ebx 
	Call WriteDec
	mov al ,':'
	Call WriteChar
	mov eax , edx
	Call WriteDec
	Call crlf
	ret

TimeFunction ENDP
;------------------------------------------------------------------------
;Generating a random number for the specific level that the user chooses 
;------------------------------------------------------------------------
RandomNumber PROC uses eax ecx edx 

      invoke GetTickCount      ; generating a random number by the time counter 
      mov edx , 0
      mov ecx , 3  
      div ecx                  ; placing it in from 0-2 range
      mov randBoardNumber ,edx

	  RET
RandomNumber ENDP
;----------------------------------------------
;Read the solved board to check the user input 
;----------------------------------------------
ReadSolvedBoard PROC uses edx ecx eax 

      mov edx,OFFSET solvedBoard
      call OpenInputFile
      mov fileHandle,eax
                                             ; Check for errors
      cmp eax,INVALID_HANDLE_VALUE                 ; error opening file?
      jne file_ok                                  ; no: skip
      jmp quit                                     ; and quit
      file_ok:
                                             ; Read the file into a buffer.
      mov edx, offset solved
      mov ecx,BUFFER_SIZE
      call ReadFromFile
      jnc check_buffer_size                        ; error reading?

      call WriteWindowsMsg
      jmp close_file
      check_buffer_size:
      cmp eax,BUFFER_SIZE                          ; buffer large enough?
      jb buf_size_ok ; yes
      jmp quit                                     ; and quit
      buf_size_ok:
      mov solved[eax],0                            ; insert null terminator

      close_file:                            
      mov eax,fileHandle
      call CloseFile
      quit:
      RET
ReadSolvedBoard ENDP
;---------------------------------------------------------------
;Read the unsolved board to add in it the user input 
;---------------------------------------------------------------
ReadUnSolvedBoard PROC uses edx ecx eax 

      mov edx,OFFSET Filename
      call OpenInputFile
      mov fileHandle,eax
                                             ; Check for errors
      cmp eax,INVALID_HANDLE_VALUE                 ; error opening file?
      jne file_ok                                  ; no: skip
      jmp quit                                     ; and quit
      file_ok:
                                             ; Read the file into a buffer.
      mov edx, offset unsolved
      mov ecx,BUFFER_SIZE
      call ReadFromFile
      jnc check_buffer_size                        ; error reading?

      call WriteWindowsMsg
      jmp close_file
      check_buffer_size:
      cmp eax,BUFFER_SIZE                          ; buffer large enough?
      jb buf_size_ok ; yes
      jmp quit                                     ; and quit
      buf_size_ok:
      mov unsolved[eax],0                            ; insert null terminator

      close_file:                            
      mov eax,fileHandle
      call CloseFile
      quit:
      RET

ReadUnSolvedBoard ENDP
;-----------------------------------------------------------------------------------------
;Checks if the user entered a correct input or not if yes it changes it in the board 
;and displayes a green message else it only displays an error red message and the correct
; inputs and wrong inputs of the user
;-----------------------------------------------------------------------------------------
Check PROC uses eax edx ecx ebx 
      
	  dec Row
	  dec Col
	  mov eax ,0
	  mov al , Row
	  mov bl , 11
	  mul bl
	  add al , Col
	  mov bl ,userunsolved[eax]
	  cmp bl , '_'
	  Jne WrongCell
	  mov bl, solved[eax]
	  cmp bl , Val
	  Jne WrongCell
	  inc Ccount
	  mov bl , Val
	  mov userunsolved[eax] , bl
	  mov unsolved[eax] , 'c'
	  dec left
	  mov al , 10 
	  mov edx , offset  CorrectAnswer
	  Call SetTextColor
	  Call WriteString
	  Call crlf
	  mov al , 15
	  Call SetTextColor
	  Call Display
	  JMP Quit
	  WrongCell :
	  inc Wcount
	  mov edx , offset ErrorMessage
	  mov al , 12
	  Call SetTextColor
	  Call WriteString
	  Call crlf
	  Quit :
	  Ret
Check ENDP
;------------------------------
;Change every zero to dash 
;------------------------------
Dash PROC uses edx ecx 
     
	 mov edx,offset userunsolved   
     mov bl , '_'  
     mov ecx , 97  
     p:
     cmp byte ptr[edx] ,'0'
     jz en                                        
     jmp k                                     
     en:
     mov [edx] , bl
	 inc left
     k:
     add edx , 1
     loop p

	 mov edx ,offset unsolved

	 mov bl , '_'  
     mov ecx , 97  
     p1:
     cmp byte ptr[edx] ,'0'
     jz en1                                        
     jmp ke1                                     
     en1:
     mov [edx] , bl
     ke1:
     add edx , 1
     loop p1

	 RET
Dash ENDP

;--------------------------------------------------------------------
; Display the choosen board for the user 
;-------------------------------------------------------------------
Display proc uses edx eax  ecx ebx esi edi

   mov edi , offset userunsolved
   mov esi ,offset unsolved
   mov ecx , 3

   Final:
   push ecx
   mov ecx ,3

   Dis:
   push ecx 
   mov al, 15
   call SetTextColor
   mov al , '|'
   call writechar
   mov ecx , 3
   L2:
   mov al ,' '
   call writechar
   push ecx
   mov ecx , 3
   L1:
   mov bl ,[edi]
   cmp bl , '_'
   jne cll
   mov al, 10
   JMP nott
   cll :
   mov al, 15
   cmp  byte ptr[esi] , 'c'
   jne nott
   mov al , 10
   nott:
   call SetTextColor
   mov al , bl 
   call writechar
   mov al ,' '
   call writechar
   inc edi
   inc esi
   Loop L1
   mov al, 15
   call SetTextColor
   mov al , '|'
   call writechar
   pop ecx 
   Loop L2
   call crlf
   pop ecx 
   add edi , 2
   add esi , 2
   Loop Dis
   call crlf
   pop ecx 
   Loop Final


ret
Display endp

View PROC uses eax edx 

   mov edi , offset userunsolved
   mov esi ,offset unsolved
   mov edx , offset solved
   mov ecx , 3

   Final:
   push ecx
   mov ecx ,3

   Dis:
   push ecx 
   mov al, 15
   call SetTextColor
   mov al , '|'
   call writechar
   mov ecx , 3
   L2:
   mov al ,' '
   call writechar
   push ecx
   mov ecx , 3
   L1:
   mov bl ,[edi]
   cmp bl , '_'
   jne cll
   mov al, 9
   mov bl, [edx]
   JMP nott
   cll :
   mov al, 15
   cmp  byte ptr[esi] , 'c'
   jne nott
   mov al , 10
   nott:
   call SetTextColor
   mov al , bl 
   call writechar
   mov al ,' '
   call writechar
   inc edi
   inc esi
   inc edx
   Loop L1
   mov al, 15
   call SetTextColor
   mov al , '|'
   call writechar
   pop ecx 
   Loop L2
   call crlf
   pop ecx 
   add edi , 2
   add esi , 2
   add edx ,2
   Loop Dis
   call crlf
   pop ecx 
   Loop Final

   RET

View ENDP

Save PROC

     mov edx ,offset Filename
	 mov ecx , lengthof Filename
	 mov ebx ,offset userunsolved
	 add ebx , 97
	 L1:
	 mov al , [edx]
	 mov [ebx] , al
	 inc edx
	 inc ebx 
	 Loop L1

	 mov edx , offset solvedboard
	 mov ecx ,offset lengthof solvedboard
	 L2:
	 mov al , [edx]
	 mov [ebx] , al
	 inc edx
	 inc ebx 
	 Loop L2



END main