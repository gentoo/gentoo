# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit versionator java-pkg-2 java-pkg-simple

MAJOR=v$(get_version_component_range 3-4)
MAJOR=$(replace_version_separator 1 ur ${MAJOR})
MY_PV=${MAJOR}-b$(get_version_component_range 5)
MY_PN=${PN/-//}
ZIP="glassfish-${MY_PV}-src.zip"

DESCRIPTION="Java Transaction API"
HOMEPAGE="https://glassfish.dev.java.net/"

SRC_URI="http://download.java.net/javaee5/${MAJOR}/promoted/source/${ZIP}"

LICENSE="|| ( CDDL GPL-2 )"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/${MY_PN}"

src_unpack() {
	default
	unzip \
		-q -o -f \
		"${DISTDIR}/${ZIP}" \
		"${MY_PN}/*" "glassfish/bootstrap/*" || die "unpacking failed"
}

src_install() {
	java-pkg-simple_src_install
}
