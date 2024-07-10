Universidad ORT Uruguay

Documentación de obligatorio
Certificado en DevOps

Estudiantes
Gonzalo Torres - 291628
Gaston Cabrera - 295726

Tutor

Federico Barceló

2024

<h2>Presentación del problema</h2>
<h2>Objetivos</h2>
<h2>Herramientas y justificacion de uso</h2>

Git
GitHub
GitHub Actions
Sonar Cloud
Docker
Visual Studio Code
Diagrams(To do)(quitar o no quitar)
Terraform
Postman
Amazon Web Services
Maven
Nginx
ECS

<h2>Estrategia de ramas</h2>
<h2>Etapas CI/CD</h2>
<h2></h2>


La rama master le da la version a la rama hotfix, se hace un arreglo bruto y se devuelve a master, un hotfix no deberia conectar a las demas ramas ya que es una version volatil y hecha con poco en consideracion
la actualizacion que hizo en el hotfix, se documentara y se intentara solucionar en la rama Develop comoalgo externo con mas cuidado
La rama bugfix le devuelve a la rama develop de la misma manera que hotfix, solo que bugfix es mas estable
