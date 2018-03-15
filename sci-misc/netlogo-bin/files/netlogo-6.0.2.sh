#!/bin/bash

BASE_DIR="$( cd "$( dirname $( readlink -f "${BASH_SOURCE[0]}" ) )" && pwd -P )"

if [[ ${JAVA_HOME+1} ]]; then
  JAVA="${JAVA_HOME}/bin/java"
else
  echo "JAVA_HOME undefined, using java from path. For control over exact java version, set JAVA_HOME"
  JAVA="java"
fi;

# -Xmx1024m             use up to 1GB RAM (edit to increase)
# -Dfile.encoding=UTF-8 ensure Unicode characters in model files are compatible cross-platform
JVM_OPTS=(-Xmx1024m -Dfile.encoding=UTF-8)
OPTS_INDEX=2

ARGS=()
INDEX=0

for arg in "$@"; do
  if [[ "$arg" == -D* ]]; then
    JVM_OPTS[OPTS_INDEX++]="$arg"
  else
    ARGS[INDEX++]="$arg"
  fi
done

RAW_CLASSPATH="args4j-2.0.12.jar:asm-all-5.0.4.jar:asm-all-5.0.4.jar:autolink-0.6.0.jar:behaviorsearch.jar:commons-codec-1.10.jar:commons-logging-1.1.1.jar:config-1.3.1.jar:flexmark-0.20.0.jar:flexmark-ext-autolink-0.20.0.jar:flexmark-ext-escaped-character-0.20.0.jar:flexmark-ext-typographic-0.20.0.jar:flexmark-formatter-0.20.0.jar:flexmark-util-0.20.0.jar:gluegen-rt-2.3.2.jar:httpclient-4.2.jar:httpcore-4.2.jar:httpmime-4.2.jar:jcommon-1.0.16.jar:jfreechart-1.0.13.jar:jhotdraw-6.0b1.jar:jmf-2.1.1e.jar:jogl-all-2.3.2.jar:json-simple-1.1.1.jar:log4j-1.2.16.jar:macro-compat_2.12-1.1.1.jar:macro-compat_2.12-1.1.1.jar:netlogo-6.0.2.jar:parboiled_2.12-2.1.3.jar:parboiled_2.12-2.1.3.jar:picocontainer-2.13.6.jar:picocontainer-2.13.6.jar:rsyntaxtextarea-2.6.0.jar:scala-library-2.12.2.jar:scala-parser-combinators_2.12-1.0.5.jar:shapeless_2.12-2.3.2.jar:shapeless_2.12-2.3.2.jar"
CLASSPATH=''

for jar in `echo $RAW_CLASSPATH | sed 's/:/ /g'`; do
  CLASSPATH="$CLASSPATH:$BASE_DIR/app/$jar"
done

CLASSPATH=`echo $CLASSPATH | sed 's/://'`

# -classpath ....         specify jars
# org.nlogo.headless.Main specify we want headless, not GUI
# "${ARGS[0]}"            pass along any additional arguments
java "${JVM_OPTS[@]}" -Dnetlogo.extensions.dir="${BASE_DIR}/app/extensions" -classpath "$CLASSPATH" org.nlogo.app.App "${ARGS[@]}"
