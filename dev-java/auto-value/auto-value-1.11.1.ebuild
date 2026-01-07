# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc test"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Immutable value-type code generation for Java 1.7+"
HOMEPAGE="https://github.com/google/auto/tree/master/value"
SRC_URI="https://github.com/google/auto/archive/${P}.tar.gz"
S="${WORKDIR}/auto-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

CP_DEPEND="
	>=dev-java/asm-9.9:0
	>=dev-java/escapevelocity-1.1:0
	>=dev-java/guava-33.5.0:0
	>=dev-java/incap-1.0.0:0
	dev-java/javapoet:0
	>=dev-java/jspecify-1.0.0:0
"

DEPEND="
	${CP_DEPEND}
	>=dev-java/checker-framework-qual-3.52.0:0
	>=dev-java/error-prone-annotations-2.45.0:0
	>=virtual/jdk-1.8:*
	test? (
		>=dev-java/compile-testing-0.23.0:0
		>=dev-java/guava-testlib-33.5.0:0
		>=dev-java/jsr305-3.0.2-r1:0
		>=dev-java/truth-1.4.5:0
	)
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_TEST_EXCLUDES=(
	# No runnable methods
	com.google.auto.value.extension.serializable.serializer.utils.TestStringSerializerFactory

	# There was 1 failure:
	# 1) getFactory_extensionsLoaded(com.google.auto.value.extension.serializable.serializer.SerializerFactoryLoaderTest)
	# value of           : getName()
	# expected to contain: TestStringSerializerFactory$TestStringSerializer
	# but was            : com.google.auto.value.extension.serializable.serializer.impl.IdentitySerializerFactory$IdentitySerializer
	# 	at com.google.auto.value.extension.serializable.serializer.SerializerFactoryLoaderTest.getFactory_extensionsLoaded(SerializerFactoryLoaderTest.java:37)
	#
	# FAILURES!!!
	# Tests run: 403,  Failures: 1
	#
	com.google.auto.value.extension.serializable.serializer.SerializerFactoryLoaderTest
)

JAVA_TEST_GENTOO_CLASSPATH="
	checker-framework-qual
	compile-testing
	escapevelocity
	guava-testlib
	incap
	javapoet
	jsr305
	junit-4
	truth
"

JAVA_TEST_SRC_DIR="value/src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	mkdir -p value/res/META-INF/services && cd $_ || die "mkdir"

	cat > javax.annotation.processing.Processor <<-JAVAX || die
		com.google.auto.value.extension.memoized.processor.MemoizedValidator
		com.google.auto.value.extension.toprettystring.processor.ToPrettyStringValidator
		com.google.auto.value.processor.AutoAnnotationProcessor
		com.google.auto.value.processor.AutoBuilderProcessor
		com.google.auto.value.processor.AutoOneOfProcessor
		com.google.auto.value.processor.AutoValueBuilderProcessor
		com.google.auto.value.processor.AutoValueProcessor
	JAVAX

	cat > com.google.auto.value.extension.serializable.serializer.interfaces.SerializerExtension <<-SER || die
		com.google.auto.value.extension.serializable.serializer.impl.ImmutableListSerializerExtension
		com.google.auto.value.extension.serializable.serializer.impl.ImmutableMapSerializerExtension
		com.google.auto.value.extension.serializable.serializer.impl.OptionalSerializerExtension
	SER

	cat > com.google.auto.value.extension.AutoValueExtension <<-AUTO || die
		com.google.auto.value.extension.memoized.processor.MemoizeExtension
		com.google.auto.value.extension.serializable.processor.SerializableAutoValueExtension
		com.google.auto.value.extension.toprettystring.processor.ToPrettyStringExtension
	AUTO
}

src_compile() {
	local cp="$(java-pkg_getjar asm asm.jar)"
	cp="${cp}:$(java-pkg_getjars --build-only checker-framework-qual,error-prone-annotations)"
	cp="${cp}:$(java-pkg_getjars escapevelocity,guava,incap,javapoet,jspecify)"

	find \
		common/src/main/java \
		service/annotations/src/main/java \
		service/processor/src/main/java \
		value/src/main/java \
		-name '*.java' > sources.lst || die "gather sources"

	einfo "compile them all"
	mkdir -p target/classes || die "mkdir target/classes"	# still needed for openjdk-8
	ejavac -d target/classes -classpath "${cp}" @sources.lst

	use doc && ejavadoc -d target/api -classpath "${cp}" -quiet @sources.lst

	einfo "package auto-value-annotations"
	# according to value/annotations/pom.xml
	find target/classes/com/google/auto/value \
		\( ! -path '*/value/*/*' -path '*/value/*.class' \) -o \
		\( ! -path '*/value/extension/memoized/*/*' -path '*/value/extension/memoized/*.class' \) -o \
		\( ! -path '*/value/extension/serializable/*/*' -path '*/value/extension/serializable/*.class' \) -o \
		\( ! -path '*/value/extension/toprettystring/*/*' -path '*/value/extension/toprettystring/*.class' \) |
		sed -e 's/^/-C /' -e 's/classes\/com/classes com/' > valueannotations || die "valueannotations"
	jar cf auto-value-annotations.jar @valueannotations || die

	einfo "package auto-value"
	# according to value/processor/pom.xml
	find target/classes/com/google/auto \( \
		-path '*/value/processor/*.class' -o \
		-path '*/value/extension/memoized/processor/*.class' -o \
		-path '*/value/extension/serializable/processor/*.class' -o \
		-path '*/value/extension/serializable/serializer/*.class' -o \
		-path '*/value/extension/toprettystring/processor/*.class' -o \
		-path '*/value/extension/AutoValueExtension*.class' \) |
		sed -e 's/^/-C /' -e 's/classes\/com/classes com/' > autovalue || die "autovalue"
	find value/src/main/java -path '*/value/processor/*.vm' |
		sed -e 's/^/-C /' -e 's/java\/com/java com/' >> autovalue || die "add .vm files"
	jar cf auto-value.jar @autovalue || die
	jar uvf auto-value.jar -C value/res . || die

	einfo "package auto-common"
	jar cf auto-common.jar -C target/classes com/google/auto/common || die

	einfo "package auto-service-annotations"
	jar cf auto-service-annotations.jar -C target/classes com/google/auto/service/AutoService.class || die

	einfo "package auto-service"
	jar cf auto-service.jar -C target/classes com/google/auto/service/processor || die
	jar uvf auto-service.jar -C service/processor/src/main/resources META-INF/services || die
}

src_test() {
	JAVA_GENTOO_CLASSPATH_EXTRA=":auto-common.jar:auto-service-annotations.jar:auto-value-annotations.jar"

	# java.lang.NoClassDefFoundError: com/google/auto/common/MoreTypes
	# means 'auto-common.jar' is also needed on processorpath.

	# get processorpath
	local pp="auto-value.jar:auto-common.jar"
	pp="${pp}:$(java-pkg_getjars --build-only guava,incap,escapevelocity,javapoet)"

	JAVAC_ARGS="-processorpath ${pp} -parameters"	# '-parameters' for MemoizedTest, pom.xml line 177

	local vm_version="$(java-config -g PROVIDES_VERSION)"
	if ver_test "${vm_version}" -ge 17; then
		# pom.xml lines 279-281
		JAVA_TEST_EXTRA_ARGS=( --add-exports=jdk.compiler/com.sun.tools.javac.{api,file,parser,tree,util}=ALL-UNNAMED)
	fi

	java-pkg-simple_src_test
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar auto-value-annotations.jar auto-common.jar auto-service-annotations.jar auto-service.jar
	use doc && docinto html && dodoc -r value/userguide
}
