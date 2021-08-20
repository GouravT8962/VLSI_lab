def reg_sel(reg_name): # function for dregister position selection
  if (reg_name == "B"): reg_pos = 0
  elif (reg_name == "C"): reg_pos = 1
  elif (reg_name == "D"): reg_pos = 2
  elif (reg_name == "E"): reg_pos = 3
  elif (reg_name == "H"): reg_pos = 4
  elif (reg_name == "L"): reg_pos = 5
  else: reg_pos = 7
  return reg_pos
  
def data_cal(data): # decimal to binary conversion of data/address
  if (int(data) >=0):
    data1 = int(data)
  else:
    data1 = int(data)+256
  sev_to_thr = int(data1/8)
  tw_to_zer = (data1%8)
  return sev_to_thr,tw_to_zer
	
def inst_cal(opn): # instruction calculation
  opn = opn.rstrip("\n")
  operation = opn.split(' ')
  opcode = 0
  ten_to_eight = 0
  seven_to_three = 0
  two_to_zero = 0
  if (operation[0] in {"ADD","ADC","SUB","SBB","ANA","ORA","XRA","CMP"}): # arithematic
    opcode = 0  
  elif (operation[0] in {"INR","DCR"}): # INR DCR
    opcode = 1
  elif (operation[0] in {"ADDM","ADCM","SUBM","SBBM","ANAM","ORAM","XRAM","CMPM"}): # arithematic
    opcode = 2   
  elif (operation[0] in {"INRM","DCRM"}): # INR DCR
    opcode = 3
  elif (operation[0] in {"CMA","CMC","STC","RET","HLT","NOP"}):
    opcode = 4
  elif (operation[0] == "ADI"):
    opcode = 5
  elif (operation[0] == "ACI"):
    opcode = 6
  elif (operation[0] == "SUI"):
    opcode = 7
  elif (operation[0] == "SBI"):
    opcode = 8
  elif (operation[0] == "ANI"):
    opcode = 9
  elif (operation[0] == "ORI"):
    opcode = 10
  elif (operation[0] == "XRI"):
    opcode = 11
  elif (operation[0] == "CPI"):
    opcode = 12
  elif (operation[0] == "LDA"):
    opcode = 13
  elif (operation[0] == "STA"):
    opcode = 14
  elif (operation[0] == "JMP"):
    opcode = 15
  elif (operation[0] == "JNZ"):
    opcode = 16
  elif (operation[0] == "JNC"):
    opcode = 17
  elif (operation[0] == "CALL"):
    opcode = 18
  elif (operation[0] == "MVIR"):
    opcode = 19
    ten_to_eight = reg_sel(operation[1])
  elif (operation[0] == "MVIM"):
    opcode = 20
    ten_to_eight = reg_sel(operation[1])
  elif (operation[0] == "MOVRR"):
    opcode = 21
    ten_to_eight = reg_sel(operation[1])
    two_to_zero = reg_sel(operation[2])
  elif (operation[0] == "MOVRM"):
    opcode = 22
    ten_to_eight = reg_sel(operation[1])
    two_to_zero = reg_sel(operation[2])
  elif (operation[0] == "MOVMR"):
    opcode = 23
    ten_to_eight = reg_sel(operation[1])
    two_to_zero = reg_sel(operation[2])
  elif (operation[0] == "MOVRA"):
    opcode = 24
    ten_to_eight = reg_sel(operation[1])
  elif (operation[0] == "MOVAR"):
    opcode = 25
    ten_to_eight = reg_sel(operation[2])
  elif (operation[0] == "MOVAM"):
    opcode = 26
    ten_to_eight = reg_sel(operation[2])
  elif (operation[0] == "MOVMA"):
    opcode = 27
    ten_to_eight = reg_sel(operation[1])
  elif (operation[0] == "MVIA"):
    opcode = 28
  else:
    opcode = 31
	
  if (operation[0] in {"ADD","ADDM"}):
    seven_to_three = 0
  elif (operation[0] in {"ADC","ADCM"}):
    seven_to_three = 1
  elif (operation[0] in {"SUB","SUBM"}):
    seven_to_three = 2
  elif (operation[0] in {"SBB","SBBM"}):
    seven_to_three = 3
  elif (operation[0] in {"ANA","ANAM"}):
    seven_to_three = 6
  elif (operation[0] in {"INR","INRM"}):
    seven_to_three = 4
  elif (operation[0] in {"DCR","DCRM"}):
    seven_to_three = 5
  elif (operation[0] in {"ORA","ORAM"}):
    seven_to_three = 7
  elif (operation[0] in {"XRA","XRAM"}):
    seven_to_three = 8
  elif (operation[0] in {"CMP","CMPM"}):
    seven_to_three = 9
  elif (operation[0] == "CMA"):
    seven_to_three = 10
  elif (operation[0] == "CMC"):
    seven_to_three = 11
  elif (operation[0] == "STC"):
    seven_to_three = 12
  elif (operation[0] == "RET"):
    seven_to_three = 13
  elif (operation[0] == "HLT"):
    seven_to_three = 14
  elif (operation[0] == "NOP"):
      seven_to_three = 15
	  
  if (operation[0] in {"ADI","ACI","SUI","SBI","ANI","ORI","XRI","CPI","LDA","STA","JMP","JNZ","JNC","CALL","MVIA"}):
    seven_to_three,two_to_zero = data_cal(operation[1])

  if (operation[0] in {"MVIR","MVIM"}): # data claculation for moving immediate type instructions
    seven_to_three,two_to_zero = data_cal(operation[2])
	
  if (operation[0] in {"ADD","ADC","SUB","SBB","ANA","ORA","XRA","CMP","INR","DCR","ADDM","ADCM","SUBM","SBBM","ANAM","ORAM","XRAM","CMPM","INRM","DCRM","MVIR","MVIM"}):
    ten_to_eight = reg_sel(operation[1]);

  opcode_str = "{:05b}".format(int(opcode))
  ten_to_eight_str = "{:03b}".format(int(ten_to_eight))
  seven_to_three_str = "{:05b}".format(int(seven_to_three))
  two_to_zero_str = "{:03b}".format(int(two_to_zero))
  instruction = (opcode*2048) + (ten_to_eight*256) + (seven_to_three*8) + (two_to_zero)
  instruction_str = "{:04X}".format(int(instruction))
  #print(opcode_str+ten_to_eight_str+seven_to_three_str+two_to_zero_str)
  #print(instruction_str)
  return instruction_str
  #return opcode_str+ten_to_eight_str+seven_to_three_str+two_to_zero_str
  
import sys

input_file = open(sys.argv[1],"r") # input file
output_file = open(sys.argv[2],"w") # output file

for line in input_file.readlines():
	output_file.write(inst_cal(line) + "\n")  # writing in output file
input_file.close()
output_file.close()