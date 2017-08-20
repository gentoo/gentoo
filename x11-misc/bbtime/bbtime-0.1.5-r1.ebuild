# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="blackbox time watcher"
HOMEPAGE="https://sourceforge.net/projects/bbtools/"
SRC_URI="mirror://sourceforge/bbtools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

DOCS=( README AUTHORS BUGS ChangeLog NEWS TODO data/README.bbtime )
PATCHES=( "${FILESDIR}"/${P}-asneeded.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_install () {
	default
	rm "${ED%/}"/usr/share/bbtools/README.bbtime || die
	# since multiple bbtools packages provide this file, install
	# it in /usr/share/doc/${PF}
	mv "${ED%/}/usr/share/bbtools/bbtoolsrc.in" \
		"${ED%/}/usr/share/doc/${PF}/bbtoolsrc.example" || die
}
