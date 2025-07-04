# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# tests are wip
JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.ongres.stringprep:stringprep:2.2"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Stringprep (RFC 3454) Java implementation"
HOMEPAGE="https://github.com/ongres/stringprep/"
SRC_URI="https://github.com/ongres/stringprep/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~ppc64"

DEPEND=">=virtual/jdk-11:*"	# module-info
RDEPEND=">=virtual/jre-1.8:*"

JAVADOC_SRC_DIRS=( {string,name,sasl}prep/src/main/java )

src_compile() {
	mkdir -p target/classes || die
	local module
	for module in stringprep nameprep saslprep; do
		einfo "Compiling ${module}"
		JAVA_JAR_FILENAME="${module}.jar"
		JAVA_SRC_DIR=( "${module}"/src/main/java{,9} )
		if [[ -d "${module}/src/main/resources" ]]; then
			JAVA_RESOURCE_DIRS="${module}/src/main/resources"
		fi
		java-pkg-simple_src_compile
		JAVA_GENTOO_CLASSPATH_EXTRA+=":${module}.jar"
		rm -r target || die
	done

	use doc && ejavadoc
}

src_install() {
	JAVA_JAR_FILENAME="stringprep.jar"
	java-pkg-simple_src_install
	java-pkg_dojar {name,sasl}prep.jar

	local module
	for module in stringprep nameprep saslprep; do
		if use source; then
			java-pkg_dosrc "${module}/src/main/java/*"
		fi
	done
}
