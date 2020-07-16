# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit python-single-r1 toolchain-funcs

DESCRIPTION="Smart card emulator, can be used with Remote Smart Card Reader"
HOMEPAGE="https://frankmorgner.github.io/vsmartcard/"
SRC_URI="https://github.com/frankmorgner/vsmartcard/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="${PYTHON_DEPS}
	media-gfx/qrencode:=
	sys-apps/pcsc-lite"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/help2man
	virtual/pkgconfig"

src_configure() {
	local myconf=(
		# workaround buggy prefix logic
		--enable-serialconfdir=$($(tc-getPKG_CONFIG) libpcsclite \
			--variable=serialconfdir)
		--enable-serialdropdir=$($(tc-getPKG_CONFIG) libpcsclite \
			--variable=usbdropdir)/serial
	)

	econf "${myconf[@]}"
}
