El archivo DevOpsBE contiene archivos necesarios para el proceso github actions, que necesariamente tiene que estar en los repositorio donde pueda leer el contenido de pom.xml de BE.

Para el funcionamiento correcto de Sonar Cloud para BE, en cada archivo pom.xml que se repite en Orders,Payments,Products y Shipping agregar en propiedades el siguiente codigo, como se muestra a continuacion(aclarar que si tiene otra propiedad no se borra)

	<properties>
		<sonar.organization>proyecto-devops-gonzalo-gaston</sonar.organization>
  		<sonar.host.url>https://sonarcloud.io</sonar.host.url>
	</properties>