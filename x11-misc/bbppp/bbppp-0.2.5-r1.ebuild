# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools eutils

DESCRIPTION="blackbox ppp frontend/monitor"
HOMEPAGE="http://sourceforge.net/projects/bbtools/"
SRC_URI="mirror://sourceforge/bbtools/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="x11-libs/libX11"
RDEPEND="${DEPEND}
	media-fonts/font-adobe-100dpi"

DOCS=( README AUTHORS BUGS ChangeLog NEWS TODO data/README.bbppp )

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc3-multiline.patch \
		"${FILESDIR}"/${PN}-asneeded.patch \
		"${FILESDIR}"/${P}-overflows.patch
	eautoreconf
}

src_install () {
	default
	rm "${D}"/usr/share/bbtools/README.bbppp
}

pkg_postinst() {
	# don't assume blackbox exists because virtual/blackbox is installed
	if [[ -x ${ROOT}/usr/bin/blackbox ]] ; then
		if ! grep bbppp "${ROOT}"/usr/bin/blackbox &>/dev/null ; then
			sed -e "s/.*blackbox/exec \/usr\/bin\/bbppp \&\n&/" blackbox | cat > blackbox
		fi
	fi
}
