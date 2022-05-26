# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/timidity-/}"

DESCRIPTION="Free and open set of instrument patches"
HOMEPAGE="http://freepats.opensrc.org/"
SRC_URI="http://freepats.opensrc.org/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~hppa ppc ppc64 ~riscv sparc x86"
RESTRICT="binchecks strip"

RDEPEND="app-eselect/eselect-timidity"

S="${WORKDIR}/${MY_PN}"

src_configure() {
	echo "dir ${EPREFIX}/usr/share/timidity/${MY_PN}" > timidity.cfg || die
	cat freepats.cfg >> timidity.cfg || die
}

src_install() {
	insinto /usr/share/timidity/${MY_PN}
	doins -r timidity.cfg Drum_000 Tone_000
	dodoc README
}

pkg_postinst() {
	eselect timidity update --global --if-unset
}
