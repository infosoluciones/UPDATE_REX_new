PROCEDURE CopiarArchivo
LPARAMETERS tcFileSource , tcFolderTarget ,tlVerbose ,tlOverWrite

*!*	tcFileSource:	Path y Archivo a copiar
*!*	tcFolderTarget:	Carpeta de Destino
*!*	tlVerbose:		=.T., Muestra un mensaje de copia realizada
*!*	tlOverWrite:	=.T., No pregunta si el archivo ya existe
*!*   Se pueden omitir todos los parámetros.

TRY
	LOCAL loFso, loEx as Exception,;
		lcFileTarget,lExito,;
		lnMess
	lnMess=6
	loFso=NEWOBJECT("Scripting.FileSystemObject")

	IF EMPTY(tcFileSource) OR NOT loFso.FileExists(tcFileSource)
		tcFileSource=GETFILE()
		IF EMPTY(tcFileSource)
			lnMess=0
		ENDIF
	ENDIF
	IF NOT EMPTY(tcFileSource)

		IF EMPTY(tcFolderTarget) OR NOT loFso.FolderExists(ADDBS(tcFolderTarget))
			tcFolderTarget=GETDIR(FULLPATH(""),"Carpeta de Destino","Copiando Archivos",64)
		ENDIF
		
		IF NOT EMPTY(tcFolderTarget)
			lcFileTarget=FORCEPATH(tcFileSource , tcFolderTarget)

			IF !tlOverWrite
				IF loFso.FileExists(lcFileTarget)
					lnMess=MESSAGEBOX(lcFileTarget+" ya existe."+CHR(13);
						+"Desea Sobrecopiar?",4,PROGRAM())
				ENDIF
			ENDIF
			
			IF lnMess=6
				loFso.CopyFile(tcFileSource , ADDBS(tcFolderTarget))
				lExito = loFso.fileExists(lcFileTarget)
			ENDIF 
		ELSE
			lnMess=0			
		ENDIF
	ENDIF
CATCH TO loex
	loex.UserValue=PROGRAM()
	
	ShowError(loex)	&& rutina de errores
FINALLY
	loFso = null
	IF tlVerbose AND VARTYPE(loex)#"O" AND lnMess=6
		MESSAGEBOX("Copia "+IIF(lExito,"Exitosa","Fallida"),0,PROGRAM())
	ENDIF
	
ENDTRY

ENDPROC

* Procedure ShowError (ejemplo)

PROCEDURE ShowError
LPARAMETERS toExcep , tlNotShow , tcCaption

tcCaption=EVL(tcCaption,"Mensaje del Sistema")
LOCAL lcMens
lcMens="Fecha "+TRANSFORM(DATETIME());
	+CHR(13)+"Mensaje: "+toExcep.message;
	+CHR(13)+"ErrorNo: "+TRANSFORM(toExcep.Errorno);
	+CHR(13)+"Llamada: "+toExcep.Uservalue 
IF _vfp.StartMode=0
	lcMens=lcMens+CHR(13)+"linea "+TRANSFORM(toExcep.lineno)
ENDIF

STRTOFILE(lcMens+CHR(13)+CHR(13),"Error_sys.log",1)
lcMens="Se ha producido un error:"+chr(13)+lcMens
IF NOT tlNotShow
	MESSAGEBOX(lcMens,0,tcCaption)
ENDIF

ENDPROC