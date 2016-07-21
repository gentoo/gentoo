# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
ESVN_PROJECT=g15tools/trunk
ESVN_REPO_URI="https://g15tools.svn.sourceforge.net/svnroot/${ESVN_PROJECT}/${PN}"

inherit subversion base eutils autotools

DESCRIPTION="The libg15 library gives low-level access to the Logitech G15 keyboard"
HOMEPAGE="http://g15tools.sourceforge.net/"
[[ $PV = *9999* ]] || SRC_URI="mirror://sourceforge/g15tools/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="=virtual/libusb-0*"
RDEPEND=${DEPEND}

DOCS=( AUTHORS README ChangeLog )

PATCHES=( "${FILESDIR}"/g15tools.patch )

src_unpack() {
	if [[ ${PV} = *9999* ]]; then
		subversion_src_unpack
	fi
}

src_prepare() {
	if [[ ${PV} = *9999* ]]; then
		subversion_wc_info
	fi
	base_src_prepare
	if [[ ${PV} = *9999* ]]; then
		eautoreconf
	fi
}

src_configure() {
	econf \
		--disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -exec rm -f {} +
}
