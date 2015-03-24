** abrir archivos locales y reemplazar
clear
cDir = "C:\rex\VENTAS\" 
nTotF = Adir(aFiles, cDir + '*.*',"D") 

_name_file = ""
For I = 1 To nTotF 
	
	IF 	ATC('D',aFiles[I,5])!= 0
**		? aFiles[I, 1], aFiles[I,2],aFiles[I,3],aFiles[I,4], aFiles[I,5]
		cDirin = cDir + aFiles[I,5]+"\"
		n = Adir(bFiles, cDirin + '*.*',"D") 
		
		FOR j=1 TO n
			** procedimiento que copia archivos
**			DO copiarArchivo WITH "f:\origen\closex.bmp","f:\destino\",.t.,.t.
			DO copiarArchivo WITH "f:\origen\closex.bmp","f:\destino\",.t.,.t.
		NEXT j
	ENDIF 

NEXT I




** copy file ("&ruta") to c:\xxxx