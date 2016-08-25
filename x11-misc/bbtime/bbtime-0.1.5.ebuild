# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils

DESCRIPTION="blackbox time watcher"
HOMEPAGE="https://sourceforge.net/projects/bbtools/"
SRC_URI="mirror://sourceforge/bbtools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86 ~x86-fbsd"
IUSE=""

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}"/${P}-asneeded.patch
	eautoreconf
}

src_install () {
	emake DESTDIR="${D}" install
	dodoc README AUTHORS BUGS ChangeLog NEWS TODO data/README.bbtime

	rm "${D}"/usr/share/bbtools/README.bbtime || die
	# since multiple bbtools packages provide this file, install
	# it in /usr/share/doc/${PF}
	mv "${D}/usr/share/bbtools/bbtoolsrc.in" \
		"${D}/usr/share/doc/${PF}/bbtoolsrc.example" || die
}
