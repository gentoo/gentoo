# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="org.antlr:stringtemplate:${PV}"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java template engine"
HOMEPAGE="https://www.stringtemplate.org/"
MY_COMMIT="68f2a42e8038f8e716e9666909ea485ee8aff45a"
DEB="3.2.1-4"
SRC_URI="https://github.com/antlr/stringtemplate3/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz
	https://sources.debian.org/data/main/s/${PN}/${DEB}/debian/patches/java21-compatibility.patch \
	-> ${PN}-${DEB}-java21-compatibility.patch"
S="${WORKDIR}/${PN}3-${MY_COMMIT}"

LICENSE="BSD-1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~x64-solaris"

CP_DEPEND="dev-java/antlr:0"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( {CHANGES,README}.txt )
PATCHES=(
	"${DISTDIR}/stringtemplate-${DEB}-java21-compatibility.patch"
	"${FILESDIR}/stringtemplate-3.2.1-TestStringTemplate.patch"
)

JAVA_SRC_DIR="src"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="test"
JAVA_TEST_RESOURCE_DIRS="test"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
}

src_compile() {
	local G; for G in action template angle.bracket.template eval group interface; do # from build.xml
		antlr -o src/org/antlr/stringtemplate/language/{,${G}.g} || die
	done
	java-pkg-simple_src_compile
}
