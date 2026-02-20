# Compilador MiniC (Flex/Bison)

Práctica de Compiladores: analizador léxico y sintáctico para un lenguaje tipo MiniC.

## Tecnologías
- C
- Flex
- Bison
- Makefile

## Archivos principales
- `lexico.l`: especificación léxica.
- `sintaxis.y`: gramática y acciones.
- `listaSimbolos.c/h`: tabla de símbolos.
- `main.c`: programa principal.
- `entrada`: fichero de prueba.

## Compilación y ejecución
```bash
make
./sintaxis entrada
```

## Qué incluye
- Reconocimiento de tokens.
- Parsing con reglas sintácticas.
- Soporte básico de tabla de símbolos.

## Nota
Uso académico/educativo.
