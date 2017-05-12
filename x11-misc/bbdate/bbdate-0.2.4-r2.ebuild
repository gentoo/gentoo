# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools

DESCRIPTION="blackbox date display"
HOMEPAGE="https://sourceforge.net/projects/bbtools"
SRC_URI="mirror://sourceforge/bbtools/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"

DOCS=( README AUTHORS BUGS ChangeLog TODO data/README.bbdate )
PATCHES=( "${FILESDIR}"/${P}-as-needed.patch )

src_prepare() {
	default
	mv configure.{in,ac} || die
	sed -i \
		-e 's|-helvetica-|-*-|g' \
		resource.cc data/${PN}.{nobb,style} || die
	eautoreconf
}

src_install () {
	default
	rm "${ED%/}"/usr/share/bbtools/README.bbdate || die
	# since multiple bbtools packages provide this file, install
	# it in /usr/share/doc/${PF}
	mv "${ED%/}"/usr/share/bbtools/bbtoolsrc.in \
		"${ED%/}"/usr/share/doc/${PF}/bbtoolsrc.example || die
}
