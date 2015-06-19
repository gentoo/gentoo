# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/timidity-freepats/timidity-freepats-20060219-r1.ebuild,v 1.8 2015/06/11 19:17:52 maekke Exp $

EAPI=5

MY_PN=${PN/timidity-/}

DESCRIPTION="Free and open set of instrument patches"
HOMEPAGE="http://freepats.opensrc.org/"
SRC_URI="${HOMEPAGE}/${MY_PN}-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm hppa ppc ppc64 x86 ~x86-fbsd"
IUSE=""

RESTRICT="binchecks strip"

RDEPEND=""
DEPEND=">=app-eselect/eselect-timidity-20061203"

S=${WORKDIR}/${MY_PN}

src_prepare() {
	echo "dir ${EPREFIX}/usr/share/timidity/${MY_PN}" > timidity.cfg || die
	cat freepats.cfg >> timidity.cfg || due
}

src_install() {
	insinto /usr/share/timidity/${MY_PN}
	doins -r timidity.cfg Drum_000 Tone_000
	dodoc README
}

pkg_postinst() {
	eselect timidity update --global --if-unset
}
