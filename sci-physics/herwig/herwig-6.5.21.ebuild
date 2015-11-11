# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=yes
inherit versionator autotools-utils fortran-2

PV1=$(get_version_component_range 1 ${PV})
PV2=$(get_version_component_range 2 ${PV})
PV3=$(get_version_component_range 3 ${PV})
MY_P=${PN}${PV1}${PV2}${PV3}
MY_PINC="$(echo ${PN}|tr '[:lower:]' '[:upper:]')${PV1}${PV2}.INC"

DESCRIPTION="High Energy Physics Event Generator"
HOMEPAGE="http://www.hep.phy.cam.ac.uk/theory/webber/Herwig/"
SRC_URI="
	${HOMEPAGE}/${MY_P}.f
	${HOMEPAGE}/${MY_P}.inc
	${HOMEPAGE}/${MY_PINC}
	doc? ( ${HOMEPAGE}/hw65_manual.pdf )"

LICENSE="all-rights-reserved"
RESTRICT="mirror bindist"

SLOT="0"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND="!sci-physics/cernlib-montecarlo[herwig]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/* "${S}"
}

src_prepare() {
	sed -i \
		-e "s/${PN}.*.inc/${MY_P}.inc/" \
		${MY_PINC} || die
	cat > configure.ac <<-EOF
		AC_INIT(${PN},${PV})
		AM_INIT_AUTOMAKE
		AC_PROG_F77
		AC_PROG_LIBTOOL
		AC_CONFIG_FILES(Makefile)
		AC_OUTPUT
	EOF
	cat > Makefile.am <<-EOF
		lib_LTLIBRARIES = lib${PN}.la
		lib${PN}_la_SOURCES = ${MY_P}.f
		include_HEADERS = \
			${MY_PINC} \
			${MY_P}.inc

	EOF
	autotools-utils_src_prepare
}

src_install() {
	autotools-utils_src_install
	use doc && dodoc "${DISTDIR}"/hw65_manual.pdf
}
