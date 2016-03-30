#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=mkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=lib
DEBUGGABLE_SUFFIX=
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/CoreLib.X.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=lib
DEBUGGABLE_SUFFIX=
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/CoreLib.X.${OUTPUT_SUFFIX}
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=core.asm pwm.asm sens.asm

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/core.o ${OBJECTDIR}/pwm.o ${OBJECTDIR}/sens.o
POSSIBLE_DEPFILES=${OBJECTDIR}/core.o.d ${OBJECTDIR}/pwm.o.d ${OBJECTDIR}/sens.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/core.o ${OBJECTDIR}/pwm.o ${OBJECTDIR}/sens.o

# Source Files
SOURCEFILES=core.asm pwm.asm sens.asm


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/CoreLib.X.${OUTPUT_SUFFIX}

MP_PROCESSOR_OPTION=18f1220
MP_LINKER_DEBUG_OPTION= 
# ------------------------------------------------------------------------------------
# Rules for buildStep: assemble
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/core.o: core.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/core.o.d 
	@${RM} ${OBJECTDIR}/core.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/core.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/core.lst\\\" -e\\\"${OBJECTDIR}/core.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/core.o\\\" \\\"core.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/core.o"
	@${FIXDEPS} "${OBJECTDIR}/core.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/pwm.o: pwm.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pwm.o.d 
	@${RM} ${OBJECTDIR}/pwm.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/pwm.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/pwm.lst\\\" -e\\\"${OBJECTDIR}/pwm.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/pwm.o\\\" \\\"pwm.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/pwm.o"
	@${FIXDEPS} "${OBJECTDIR}/pwm.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/sens.o: sens.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/sens.o.d 
	@${RM} ${OBJECTDIR}/sens.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/sens.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -d__DEBUG -d__MPLAB_DEBUGGER_SIMULATOR=1 -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/sens.lst\\\" -e\\\"${OBJECTDIR}/sens.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/sens.o\\\" \\\"sens.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/sens.o"
	@${FIXDEPS} "${OBJECTDIR}/sens.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
else
${OBJECTDIR}/core.o: core.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/core.o.d 
	@${RM} ${OBJECTDIR}/core.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/core.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/core.lst\\\" -e\\\"${OBJECTDIR}/core.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/core.o\\\" \\\"core.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/core.o"
	@${FIXDEPS} "${OBJECTDIR}/core.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/pwm.o: pwm.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/pwm.o.d 
	@${RM} ${OBJECTDIR}/pwm.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/pwm.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/pwm.lst\\\" -e\\\"${OBJECTDIR}/pwm.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/pwm.o\\\" \\\"pwm.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/pwm.o"
	@${FIXDEPS} "${OBJECTDIR}/pwm.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
${OBJECTDIR}/sens.o: sens.asm  nbproject/Makefile-${CND_CONF}.mk
	@${MKDIR} "${OBJECTDIR}" 
	@${RM} ${OBJECTDIR}/sens.o.d 
	@${RM} ${OBJECTDIR}/sens.o 
	@${FIXDEPS} dummy.d -e "${OBJECTDIR}/sens.err" $(SILENT) -c ${MP_AS} $(MP_EXTRA_AS_PRE) -q -p$(MP_PROCESSOR_OPTION) -u  -l\\\"${OBJECTDIR}/sens.lst\\\" -e\\\"${OBJECTDIR}/sens.err\\\" $(ASM_OPTIONS)   -o\\\"${OBJECTDIR}/sens.o\\\" \\\"sens.asm\\\" 
	@${DEP_GEN} -d "${OBJECTDIR}/sens.o"
	@${FIXDEPS} "${OBJECTDIR}/sens.o.d" $(SILENT) -rsi ${MP_AS_DIR} -c18 
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: archive
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/CoreLib.X.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_AR} $(MP_EXTRA_AR_PRE) -c dist/${CND_CONF}/${IMAGE_TYPE}/CoreLib.X.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}     
else
dist/${CND_CONF}/${IMAGE_TYPE}/CoreLib.X.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	@${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_AR} $(MP_EXTRA_AR_PRE) -c dist/${CND_CONF}/${IMAGE_TYPE}/CoreLib.X.${OUTPUT_SUFFIX} ${OBJECTFILES_QUOTED_IF_SPACED}     
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell "${PATH_TO_IDE_BIN}"mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
