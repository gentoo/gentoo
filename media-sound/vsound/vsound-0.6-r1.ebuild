# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A virtual audio loopback cable"
HOMEPAGE="http://www.vsound.org/"
SRC_URI="http://www.vsound.org/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc sparc x86"
IUSE=""

RDEPEND="media-sound/sox:="
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-stdout.patch
	"${FILESDIR}"/${P}-fix-build-system.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}

pkg_postinst() {
	elog
	elog "To use this program to, for instance, record audio from realplayer:"
	elog "vsound realplay realmediafile.rm"
	elog
	elog "Or, to listen to realmediafile.rm at the same time:"
	elog "vsound -d realplay realmediafile.rm"
	elog
	elog "See ${HOMEPAGE} or /usr/share/doc/${PF}/README.bz2 for more info"
	elog
}
