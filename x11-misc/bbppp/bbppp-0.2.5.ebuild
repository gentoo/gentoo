# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit autotools eutils

DESCRIPTION="blackbox ppp frontend/monitor"
HOMEPAGE="https://sourceforge.net/projects/bbtools/"
SRC_URI="mirror://sourceforge/bbtools/${PN}/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND="x11-libs/libX11"

src_prepare() {
	epatch "${FILESDIR}"/${P}-gcc3-multiline.patch \
		"${FILESDIR}"/${PN}-asneeded.patch
	eautoreconf
}

src_install () {
	emake DESTDIR="${D}" install || die
	dodoc README AUTHORS BUGS ChangeLog NEWS TODO data/README.bbppp || die
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
