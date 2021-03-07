# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Testing framework inspired by JUnit and NUnit with new features"
HOMEPAGE="https://testng.org/"
SRC_URI="https://github.com/cbeust/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="Apache-2.0"
KEYWORDS="amd64 x86"
SLOT="0"
IUSE="test"
RESTRICT="test" # Occasionally fail or run *REALLY* slowly.

CDEPEND="dev-java/bsh:0
	dev-java/guice:4
	dev-java/junit:4
	dev-java/ant-core:0
	dev-java/snakeyaml:0
	dev-java/jcommander:0"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.7
	test? ( dev-java/assertj-core:2 )"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.7"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="src/main/java"
JAVA_GENTOO_CLASSPATH="ant-core,bsh,guice-4,jcommander,junit-4,snakeyaml"

java_prepare() {
	java-pkg_clean ! -path "./src/*"

	cp -v src/generated/java/org/testng/internal/VersionTemplateJava \
	   src/main/java/org/testng/internal/Version.java || die
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar src/main/resources
}

src_test() {
	local DIR=src/test/java
	local RES=src/test/resources
	local CP=${PN}.jar:$(java-pkg_getjars --with-dependencies "${JAVA_GENTOO_CLASSPATH},assertj-core-2")

	ejavac -cp "${CP}" -d ${DIR} $(find ${DIR} -name "*.java")
	java -cp "${RES}:${DIR}:${CP}" -Dtest.resources.dir=${RES} org.testng.TestNG -listener test.invokedmethodlistener.MyListener src/test/resources/testng.xml || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dolauncher ${PN} --main org.testng.TestNG
	java-pkg_register-ant-task

	dodoc {ANNOUNCEMENT,CHANGES,TODO}.txt

	if use doc; then
		docinto html
		dodoc -r doc
	fi
}
