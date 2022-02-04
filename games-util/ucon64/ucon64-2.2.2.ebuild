# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="The backup tool and wonderful emulator's Swiss Army knife program"
HOMEPAGE="http://ucon64.sourceforge.net/"
SRC_URI="mirror://sourceforge/ucon64/${P}-src.tar.gz"
S="${WORKDIR}/${P}-src/src"

LICENSE="GPL-2+ LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug usb zlib"

RDEPEND="
	usb? ( virtual/libusb:0 )
	zlib? ( sys-libs/zlib:= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-respect-flags.patch
)

src_prepare() {
	default

	sed "/discmage.so/s|.* \"|\"${EPREFIX}/usr/$(get_libdir)/${PN}/|" \
		-i ucon64_misc.c || die
}

src_configure() {
	local econfargs=(
		$(use_enable debug)
		$(use_with usb libusb)
		$(use_with zlib)
		--enable-ppdev
		--with-libcd64
		--with-libdiscmage
	)
	econf "${econfargs[@]}"

	tc-export AR CC LD
}

src_install() {
	dobin ucon64

	exeinto /usr/$(get_libdir)/${PN}
	doexe libdiscmage/discmage.so

	docinto html
	dodoc -r ../images ../{changes,developers,faq,hardware,readme}.html
}

pkg_postinst() {
	if [[ ! ${REPLACING_VERSIONS} ]]; then
		elog "Be sure to check ~/.ucon64rc for some options after"
		elog "you've run uCON64 for the first time."
	fi
}
