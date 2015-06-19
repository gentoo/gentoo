# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sci-physics/herwig/herwig-6.5.10.ebuild,v 1.5 2013/06/04 18:00:58 bicatali Exp $

EAPI=2

inherit versionator autotools fortran-2

PV1=$(get_version_component_range 1 ${PV})
PV2=$(get_version_component_range 2 ${PV})
PV3=$(get_version_component_range 3 ${PV})
MY_P=${PN}${PV1}${PV2}${PV3}
MY_PINC="$(echo ${PN}|tr '[:lower:]' '[:upper:]')${PV1}${PV2}.INC"

DESCRIPTION="High Energy Physics Event Generator"
HOMEPAGE="http://hepwww.rl.ac.uk/theory/seymour/herwig/"

COM_URI="http://hepwww.rl.ac.uk/theory/seymour/${PN}"
SRC_URI="
	${COM_URI}/${MY_P}.f
	${COM_URI}/${MY_P}.inc
	${COM_URI}/${MY_PINC}"

LICENSE="all-rights-reserved"
RESTRICT="mirror bindist"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="!sci-physics/cernlib-montecarlo[herwig]"
RDEPEND=""

S="${WORKDIR}"

src_unpack() {
	cp "${DISTDIR}"/* "${S}"
}

src_prepare() {
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
		pkginclude_HEADERS = \
			${MY_PINC} \
			${MY_P}.inc

	EOF
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
