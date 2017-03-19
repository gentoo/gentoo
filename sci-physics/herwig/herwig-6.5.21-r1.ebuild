# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools eutils fortran-2 versionator

PV1=$(get_version_component_range 1 ${PV})
PV2=$(get_version_component_range 2 ${PV})
PV3=$(get_version_component_range 3 ${PV})
MY_P=${PN}${PV1}${PV2}${PV3}
MY_PINC="${PN^^}${PV1}${PV2}.INC"

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
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc static-libs"

RDEPEND="!sci-physics/cernlib-montecarlo[herwig]"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/{"${MY_P}".f,"${MY_P}".inc,"${MY_PINC}"} "${S}" || die
}

src_prepare() {
	sed -i \
		-e "s/${PN}.*.inc/${MY_P}.inc/" \
		${MY_PINC} || die
	cat > configure.ac <<-EOF || die
		AC_INIT(${PN},${PV})
		AM_INIT_AUTOMAKE
		AC_PROG_F77
		AC_PROG_LIBTOOL
		AC_CONFIG_FILES(Makefile)
		AC_OUTPUT
	EOF
	cat > Makefile.am <<-EOF || die
		lib_LTLIBRARIES = lib${PN}.la
		lib${PN}_la_SOURCES = ${MY_P}.f
		include_HEADERS = \
			${MY_PINC} \
			${MY_P}.inc

	EOF
	eapply_user
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files
	use doc && dodoc "${DISTDIR}"/hw65_manual.pdf
}
