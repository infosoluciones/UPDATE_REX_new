PROCEDURE CopiarArchivo
LPARAMETERS tcFileSource , tcFolderTarget ,tlVerbose ,tlOverWrite

*!*	tcFileSource:	Path y Archivo a copiar
*!*	tcFolderTarget:	Carpeta de Destino
*!*	tlVerbose:		=.T., Muestra un mensaje de copia realizada
*!*	tlOverWrite:	=.T., No pregunta si el archivo ya existe

TRY
	LOCAL loFso as Object,loFile as Object, loEx as Exception,;
		lcFileTarget,lExito,lnMess
	lnMess=6
	loFso=NEWOBJECT("Scripting.FileSystemObject")

	IF EMPTY(tcFileSource) OR NOT loFso.FileExists(tcFileSource)
		tcFileSource=GETFILE()
		IF EMPTY(tcFileSource)
			lnMess=0
		ENDIF
	ENDIF
	IF NOT EMPTY(tcFileSource)
		*** Consulta el verdadero nombre del archivo a copiar ***

		loFile=loFso.GetFile(tcFilesource)
		tcFileSource=ADDBS(JUSTPATH(tcFileSource))+loFile.Name
		
		*********************************************************
			
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
	
	*ShowError(loex)	&& rutina de errores
FINALLY
	loFile = null
	loFso = null
	IF tlVerbose AND VARTYPE(loex)#"O" AND lnMess=6
		MESSAGEBOX("Copia "+IIF(lExito,"Exitosa","Fallida"),0,PROGRAM())
	ENDIF
	
ENDTRY