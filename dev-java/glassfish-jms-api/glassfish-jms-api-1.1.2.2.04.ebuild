# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"
JAVA_PKG_IUSE="doc source"

inherit versionator java-pkg-2 java-ant-2

DESCRIPTION="Java Transaction API"
HOMEPAGE="https://glassfish.dev.java.net/"
MAJOR=v$(get_version_component_range 3-4)
MAJOR=$(replace_version_separator 1 ur ${MAJOR})
MY_PV=${MAJOR}-b$(get_version_component_range 5)
MY_PN=${PN/-//}
ZIP="glassfish-${MY_PV}-src.zip"
SRC_URI="http://download.java.net/javaee5/${MAJOR}/promoted/source/${ZIP}"

LICENSE="|| ( CDDL GPL-2 )"
SLOT="0"
KEYWORDS="~amd64 ~arm x86 ~amd64-fbsd"

IUSE=""

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
		app-arch/unzip
		${COMMON_DEP}"

S=${WORKDIR}/${MY_PN}

src_unpack() {
	unzip -q "${DISTDIR}/${ZIP}" "${MY_PN}/*" "glassfish/bootstrap/*" \
		|| die "unpacking failed"
	einfo "${S}"
}

EANT_BUILD_TARGET="all"
EANT_EXTRA_ARGS="-Djavaee.jar=\"${S}/${PN}.jar\""
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
