# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
JAVA_PKG_IUSE="doc source examples test"

inherit eutils java-pkg-2 java-ant-2

MY_PN="${PN/jdbc-/}"
DESCRIPTION="JDBC Type 2 and 4 drivers for Firebird SQL server"
HOMEPAGE="http://jaybirdwiki.firebirdsql.org/"
SRC_URI="https://github.com/FirebirdSQL/${MY_PN}/archive/v${PV}.zip"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~ppc"
IUSE="jni"

CDEPEND="dev-java/junit:4
	dev-java/antlr:4
	dev-java/log4j:0
	dev-java/glassfish-connector-api:0"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.6
	app-arch/unzip
	jni? ( dev-java/cpptasks )
	test? ( dev-java/ant-junit:0 )"

S="${WORKDIR}/${MY_PN}-${PV}"

java_prepare() {
	# prevent test/sources/javadoc from being built unless wanted
	sed -i -e 's|name="jar-test" depends="compile"|name="jar-test" depends="compile" if="tests"|' \
		"${S}/build/archive.xml" || die
	sed -i -e 's|name="compile-examples"|name="compile-examples" if="examples"|' \
		-e 's|,set-jdbc-42-test"|,set-jdbc-42-test" if="tests"|' \
		"${S}/build/compile.xml" || die

	# JAVA_ANT_ENCODING doesn't work because it doesn't like entities
	java-ant_xml-rewrite -f build.xml -c -e javac -a encoding -v ISO-8859-1

	cd "${S}/lib/"
	rm -v *.jar

	cd "${S}/src/lib/"
	rm -v *.jar *.zip

	java-pkg_jar-from --build-only glassfish-connector-api \
		glassfish-connector-api.jar connector-api-1.5.jar

	# the build.xml unpacks this and uses stuff
	touch empty
	jar cf mini-j2ee.jar empty
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="antlr:4,glassfish-connector-api,log4j"
EANT_BUILD_TARGET="jars"
EANT_DOC_TARGET="javadocs"

src_compile() {
	java-pkg_filter-compiler jikes
	use jni && ANT_TASKS="cpptasks"

	# This is nonsense, I know, but it works.
	if use test; then
		EANT_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"
	fi

	java-pkg-2_src_compile $(use test && echo "-Dtests=true") \
		$(use jni && echo "compile-native")
}

src_install() {
	cd "${S}/output/lib/"
	java-pkg_newjar ${MY_PN}-${PV}.jar ${PN}.jar

	for jar in full; do
		java-pkg_newjar ${MY_PN}-${jar}-${PV}.jar ${MY_PN}-${jar}.jar || die "java-pkg_newjar ${MY_PN}-${jar}.jar failed"
	done
	if use test; then
		java-pkg_newjar ${MY_PN}-test-${PV}.jar ${MY_PN}-${jar}.jar || die "java-pkg_newjar ${MY_PN}-${jar}.jar failed"
	fi

	if use jni; then
		cd "${S}/output/native"
		sodest="/usr/lib/"
		local so_arch
		if use amd64; then
			so_arch="x64"
		elif use x86; then
			so_arch="x86"
		fi
		java-pkg_doso libjaybird22_${so_arch}.so || die \
			"java-pkg_doso ${sodest}libjaybird22.so failed"
	fi

	cd "${S}"

	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r examples || die "installing examples failed"
	fi

	use source && java-pkg_dosrc "${S}"/src/*/org

	cd "${S}/output"
	use doc && java-pkg_dohtml -r docs/
	dodoc etc/default.mf
	dohtml etc/*.html
}

src_test() {
	#
	# Warning about timeouts without Firebird installed and running Locally
	#
	ewarn "You will experience long timeouts when running junit tests"
	ewarn "without Firebird installed and running locally. The tests will"
	ewarn "complete without Firebird, but network timeouts prolong the"
	ewarn "testing phase considerably."
	ANT_TASKS="ant-junit" eant all-tests-pure-java
}
