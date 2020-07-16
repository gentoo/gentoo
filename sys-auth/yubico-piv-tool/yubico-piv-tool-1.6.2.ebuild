# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Command line tool for the YubiKey PIV application"
SRC_URI="https://github.com/Yubico/yubico-piv-tool/archive/yubico-piv-tool-${PV}.tar.gz"
HOMEPAGE="https://developers.yubico.com/yubico-piv-tool/ https://github.com/Yubico/yubico-piv-tool"

LICENSE="BSD-2"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/openssl:0=[-bindist]
	sys-apps/pcsc-lite
"
DEPEND="${RDEPEND}
	dev-util/gengetopt
	sys-apps/help2man
	virtual/pkgconfig
	test? ( dev-libs/check )
"

S=${WORKDIR}/${PN}-${P}

src_prepare() {
	default

	if ! use test; then
		sed -i -e "/PKG_CHECK_MODULES(\[CHECK/d" configure.ac || die
		sed -i -e "s/@CHECK_CFLAGS@//" -e "s/@CHECK_LIBS@//" */*/Makefile.am || die
	fi

	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	rm "${D}"/usr/$(get_libdir)/*.la || die
}
