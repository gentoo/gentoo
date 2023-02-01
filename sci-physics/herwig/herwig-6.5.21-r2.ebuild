# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools fortran-2

MY_P=${PN}$(ver_rs 1- '')
MY_PINC="${PN^^}$(ver_cut 1)$(ver_cut 2).INC"

DESCRIPTION="High Energy Physics Event Generator"
HOMEPAGE="https://www.hep.phy.cam.ac.uk/theory/webber/Herwig/"
SRC_URI="
	https://www.hep.phy.cam.ac.uk/theory/webber/Herwig/${MY_P}.f
	https://www.hep.phy.cam.ac.uk/theory/webber/Herwig/${MY_P}.INC
	https://www.hep.phy.cam.ac.uk/theory/webber/Herwig/${MY_PINC}
	doc? ( https://www.hep.phy.cam.ac.uk/theory/webber/Herwig/hw65_manual.pdf )"
S="${WORKDIR}"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"

IUSE="doc static-libs"
RESTRICT="mirror bindist"

DEPEND="${RDEPEND}"

src_unpack() {
	cp "${DISTDIR}"/{"${MY_P}".f,"${MY_P}".INC,"${MY_PINC}"} "${S}" || die
}

src_prepare() {
	sed -i \
		-e "s/${PN}.*.inc/${MY_P}.INC/" \
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
			${MY_P}.INC

	EOF
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
	use doc && dodoc "${DISTDIR}"/hw65_manual.pdf
}
