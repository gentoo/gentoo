# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == *9999 ]]; then
	inherit autotools subversion
	ESVN_PROJECT=g15tools/trunk
	ESVN_REPO_URI="https://svn.code.sf.net/p/g15tools/code/trunk/${PN}"
else
	KEYWORDS="amd64 ppc ppc64 x86"
	SRC_URI="mirror://sourceforge/g15tools/${P}.tar.bz2"
fi

DESCRIPTION="The libg15 library gives low-level access to the Logitech G15 keyboard"
HOMEPAGE="https://sourceforge.net/projects/g15tools/"

LICENSE="GPL-2"
SLOT="0"

RDEPEND="virtual/libusb:0"
DEPEND="${RDEPEND}"

src_prepare() {
	default
	[[ ${PV} == *9999 ]] && eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default

	# no static archives
	find "${ED}" -type f -name '*.la' -delete || die
}
