# Parser

Proyecto elaborado para la materia CI3661 - Lenguajes de Programación I en el 
trimestre Enero-Marzo 2021.

El proyecto consiste en la elaboración de un *parser* de lenguaje natural en 
inglés. Se ha simplificado la profundidad del parse por motivos de tiempo, tal
y como es explicado en el enunciado del proyecto.

## ¿Cómo correr el programa?

Para ejecutar el *parser* debe inciar el interpretador de **Prolog** con el 
archivo cargado, esto lo puede hacer a través de:

```bash
swipl -s parser.pro
```

Si lo desea, puede cargar el programa desde el interpretador con:

```prolog
consult('parser.pro').
```

**IMPORTANTE:** Estas instrucciones asumen que usted se encuentra en el mismo
directorio que el archivo `parser.pro`.

Una vez cargado el *parse* con cualquiera de los métodos descritos, puede 
ejcutar cualquiera de las frases de prueba con:

```prolog
main('<frase_de_prueba>').
```

**IMPORTANTE:** La frase debe estar contenida en comillas simples.

## Detalles Relevantes de la Implementación

Dada la dificultad del *parsing* de las oraciones en tercera persona del 
singular, se decidió separar las oraciones en dos tipos: oraciones en tercera
persona del singular y todas las demás. De esta manera, se unificaron todos los 
demás predicados para el resto de las oraciones, evadiendo la repetición de 
código.

En cuanto a la cadena de recorrido del *parser*, se utilizo una lista con 
diferentes átomos que representa la estructura de la misma. No todos los 
predicados poseen un átomo que los identifique, ya que esto haría engorrosa la
lectura del formato de salida. Se simplificó de manera que sea lo más entendible 
posible.

En líneas generales, las oraciones tienen la estructura de sujeto, verbo y 
complemento. En el *parsing* del sujeto se identifica si es de la tercera
persona del singular, y en función de ello se unifica con el verbo para que la
frase tenga coherencia.

Finalmente, para la defición de vocabulario se usaron predicados para definir 
los átomos que son validados a través de una regla de la gramática que certifica
que cumplen la condición de ser de ese tipo. Existen palabras definidas en dos
tipos de palabras distintas, esto es debido a que la palabra puede ser usada
en dos contextos distintos. Por ejemplo, podemos usar la palabra 'HBO' 
refiriéndonos a una plataforma donde son proyectados programas de televisión o
películas o como una empresa, en las que temrinan siendo interpretados como 
el complemento de una adverbio de lugar o un simple sustantivo.  

## Ejemplos

Puede utilizar las siguientes frases para probar el *parser*:
* Manuel and Amin will get a nice grade
* Amin cooks Chivo with Coco
* Manuel works at MAC today , he will work at Amazon tomorrow
* Amin likes Apure and Caracas
* Manuel and Amin played good games yesterday  

Adicionalmente, puede probar con cualquiera de las oraciones definidas en el
enunciado del proyecto. Si desea agregar más vocabulario, solo debe adicionar
las palabras pertinentes en cada una de las categorías a las cuales corresponda.
