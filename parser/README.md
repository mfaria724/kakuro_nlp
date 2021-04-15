# **Proyecto III**

Proyecto elaborado para la materia CI3661 - Lenguajes de Programación I en el 
trimestre Enero-Marzo 2021.

## **Kakuro**
La primera parte del proyecto consiste en la elaboración de un *solver* de kakuros, el cual es un juego
muy parecido al sudoku. 

### **¿Cómo correr el programa?**

Para ejecutar el *solver* debe inciar el interpretador de **Prolog** con el 
archivo cargado, esto lo puede hacer a través de:

```bash
swipl -s kakuro.pl
```

Si lo desea, puede cargar el programa desde el interpretador con:

```prolog
consult('kakuro.pl').
```

**IMPORTANTE:** Estas instrucciones asumen que usted se encuentra en el mismo
directorio que el archivo `kakuro.pl`.

Una vez cargado el *solver* con cualquiera de los métodos descritos, puede 
leer algun archivo `TXT` con un tablero de kakuro siguiendo la sintaxis

```txt
[
    clue(<X>, <Y>, <Sum>, [blank(<N>, <M>), ...])
    ... 
].
```

Donde `<X>,<Y>` son las coordenadas del `<clue>`, `<Sum>` la suma y `[blank(<N>, <M>), ...]` las casillas blancas que conforman el `clue`, siguiendo la restricción de que dichas casillas deben ser una fila a la derecha o una columna debajo de la posición del `clue`. Un tablero válido de kakuro es:

```
[
  clue(1, 0, 23, [blank(1,1), blank(1,2), blank(1,3)]),
  clue(2, 0, 24, [blank(2,1), blank(2,2), blank(2,3)]),
  clue(0, 1, 16, [blank(1,1), blank(2,1)]),
  clue(0, 2, 17, [blank(1,2), blank(2,2)]),
  clue(0, 3, 14, [blank(1,3), blank(2,3)])
].
```

Para cargar un archivo con un tablero de kakuro ejecute

```prolog
readKakuro(Kakuro).
```

El programa le pedirá introducir la ruta hacia el archivo, para luego unificar el tablero con la variable `Kakuro`. Ahora, para obtener una solución de ese tablero, en caso de haberla, ejecute

```prolog
readKakuro(Kakuro), valid(Kakuro, Solution). 
```

Almacenando dicha solución en la variable `Solution`, o dando `false` todo el predicado en caso de no haberla.

### **Detalles Relevantes de la Implementación**

Nuestra implementación se divide en tres partes. 

#### **Correctitud del tablero**

La primera consiste en verificar que la construcción de un tablero kákuro es válida, para ello, primero revisa que cada `clue` individual es válido, lo cual se cumple si tienen la siguiente estructura:

```prolog
clue(<X>, <Y>, <Sum>, [blank(<N>, <M>), ...]
```

Tal que `<X>, <Y>, <Sum>` son positivos, cada `blank(<N>, <M>)` cumple con que `<N>, <M>` son positivos y la lista de `blanks` corresponde a una fila a la derecha o una columna debajo de la posición `<X>, <Y>`. La regla que verifica una lista de `clues` es `verifyClues`. 

Después, se revisa que cada casilla tenga a lo sumo 2 `clues`. Para ello llevamos un contador inicializado en 1 (el `clue` actual ya se está contando), y se disminuye ese contador si se consigue otro `clue` en la misma posición. Si el contador llega a 0 y se consigue otro `clue`, entonces el tablero no es válido. La regla encargada de verificar esto es `atMost2clues`.

Finalmente se verifica que ningún `clue` está en alguna `blank` de otro `clue`. Para ello, para cada otro `clue` se compara su primer y su último `blank` con la posición del `clue` actual. La regla encargada de hacer esto es `clueNotInAnyClue`.

#### **Correctitud de la solución**

Cada casilla solución se identifica con un predicado `fill(blank(<N>, <M>), <Value>)`, donde el `blank` indica su posición, y `<Value>` indica el valor de esa casilla. Luego, una solución consiste en una lista de `fills`. 

Dada una solución, se verifica primero se verifica que para cada `clue`, sus `fills` correspondientes tienen todos números distintos. Para obtener los `fills` de un `clue` se recorre la lista de `fills` y se toma únicamente el primer `fill` que corresponda con la posición buscada. La razón de hacer esto es prohibirle a `Prolog` seguir buscando a través de la lista, ya que en caso de hacerlo así, al momento de tener que generar una solución creará multiples `fills` en la misma posición con los valores que está buscando, lo cual no solo hace que la solución sea inválida, sino que la ejecución podría no terminar. Algo importante a destacar es que en este momento también se verifica que cada `fill` contiene un dígito. Originalmente para hacer esto haciamos que el valor de los `fill` fuera mayor a 0 y menor a 10. Sin embargo esto daba problemas al tener que buscar una solución en lugar de verificarla, pues `Prolog` no permite hacer la comparación `X > 0`, siendo `X` una variable. Así que, en lugar de eso, simplemente verificamos que `X` es miembro de la lsita que contiene dichos dígitos, y eso solucionó el problema. La regla encargada de verificar que todos los números de cada `clue` son distintos es `correctClue`.

Una vez obtenida una configuración válida para una posible solución, se verifica que los `fills` correspondientes a cada `clue` suman el valor correcto. La regla encargada de hacer esto es `correctAllSumClues`.

Después se verifica que cada `fill` está completamente instanciada, es decir, es `ground`. La razón de esto es podar la lista de aquellos `fills` que `Prolog` haya creado para satisfacer la solución pero que no son necesarios realmente.

Luego, se verifica que no hay dos `fills` en la misma posición. Esta verificación se hace de último, pues si estuviera de primero, la regla no seria capaz de generar soluciones, pues originalmente la lista de `fills` serán variables, y no se puede verificar la desigualdad entre dos variables.

Finalmente, solo faltaría verificar la unicidad de la solución. Para ello se intenta generar una solución distinta. Esto hace que la ejecución sea muy lenta, pues en caso de que se cumpla la unicidad, el programa debe recorrer todo el espacio de soluciones posibles.

Un ejemplo de solución es:
```prolog
[
  fill(blank(1,1), 9),
  fill(blank(2,1), 7),
  fill(blank(1,2), 8),
  fill(blank(2,2), 9),
  fill(blank(1,3), 6),
  fill(blank(2,3), 8),
  fill(blank(3,3), 5)
].
```
El cual corresponde al tablero mostrado de ejemplo anteriormente.

#### **Lectura de kakuros**

No hay mucho que decir aquí, consiste en abrir un archivo y leer el primer predicado que este contenga. Adicionalmente se creó la regla `readSolution` que nos permite cargar una solución y verificar su validez respecto a un tablero.

## **Parser**

La segunda parte del proyecto consiste en la elaboración de un *parser* de lenguaje natural en 
inglés. Se ha simplificado la profundidad del parse por motivos de tiempo, tal
y como es explicado en el enunciado del proyecto.

### **¿Cómo correr el programa?**

Para ejecutar el *parser* debe inciar el interpretador de **Prolog** con el 
archivo cargado, esto lo puede hacer a través de:

```bash
swipl -s parser.pl
```

Si lo desea, puede cargar el programa desde el interpretador con:

```prolog
consult('parser.pl').
```

**IMPORTANTE:** Estas instrucciones asumen que usted se encuentra en el mismo
directorio que el archivo `parser.pl`.

Una vez cargado el *parse* con cualquiera de los métodos descritos, puede 
ejecutar cualquiera de las frases de prueba con:

```prolog
main('<frase_de_prueba>').
```

**IMPORTANTE:** La frase debe estar contenida en comillas simples.

### **Detalles Relevantes de la Implementación**

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

### Ejemplos

Puede utilizar las siguientes frases para probar el *parser*:
* Manuel and Amin will get a nice grade
* Amin cooks Chivo with Coco
* Manuel works at MAC today , he will work at Amazon tomorrow
* Amin likes Apure and Caracas
* Manuel and Amin played good games yesterday  

Adicionalmente, puede probar con cualquiera de las oraciones definidas en el
enunciado del proyecto. Si desea agregar más vocabulario, solo debe adicionar
las palabras pertinentes en cada una de las categorías a las cuales corresponda.
