# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java Transaction API"
HOMEPAGE="https://glassfish.dev.java.net/"
MAJOR=v$(ver_cut 3-4)
MAJOR=${MAJOR/./ur}
MY_PV=${MAJOR}-b$(ver_cut 5)
MY_PN=${PN/-//}
ZIP="glassfish-${MY_PV}-src.zip"
SRC_URI="https://download.java.net/javaee5/${MAJOR}/promoted/source/${ZIP}"

LICENSE="|| ( CDDL GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.4"
DEPEND=">=virtual/jdk-1.4"
BDEPEND="app-arch/unzip"

S=${WORKDIR}/${MY_PN}

src_unpack() {
	unzip -q "${DISTDIR}/${ZIP}" "${MY_PN}/*" "glassfish/bootstrap/*" \
		|| die "unpacking failed"
}

EANT_BUILD_TARGET="all"
EANT_EXTRA_ARGS="-Djavaee.jar=${S}/${PN}.jar"
EANT_DOC_TARGET=""

src_compile() {
	java-pkg-2_src_compile
	if use doc; then
		javadoc -d javadoc -sourcepath src/java -subpackages javax || die "javadoc failed"
	fi
}
src_install() {
	java-pkg_dojar *.jar
	use doc && java-pkg_dojavadoc javadoc
	use source && java-pkg_dosrc src/java/javax
}
