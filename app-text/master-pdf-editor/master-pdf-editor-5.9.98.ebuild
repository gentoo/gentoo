# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop xdg

DESCRIPTION="A complete solution for viewing and editing PDF files"
HOMEPAGE="https://code-industry.net/free-pdf-editor/"
MyPN="${PN}-${PV%%.*}"
SRC_URI="https://code-industry.net/public/${P}-1-qt6.9.2.x86_64.tar.gz
	https://dev.gentoo.org/~grozin/${MyPN}.tar.bz2"
S="${WORKDIR}/${MyPN}"

LICENSE="master-pdf-editor"
SLOT="0"
KEYWORDS="~amd64"
RESTRICT="mirror"

RDEPEND="
	app-arch/bzip2
	app-arch/zstd
	app-crypt/libb2
	dev-libs/double-conversion
	dev-libs/expat
	dev-libs/glib
	dev-libs/gmp
	dev-libs/icu
	dev-libs/leancrypto
	dev-libs/libffi
	dev-libs/libpcre2
	dev-libs/libtasn1
	dev-libs/libunistring
	dev-libs/libusb
	dev-libs/libxml2
	dev-libs/md4c
	dev-libs/nettle
	dev-libs/openssl
	dev-libs/pkcs11-helper
	dev-qt/qt5compat:6
	dev-qt/qtbase:6[concurrent,dbus,gui,network,widgets,xml]
	dev-qt/qtdeclarative:6
	dev-qt/qtsvg:6
	media-gfx/graphite2
	media-gfx/sane-backends
	media-libs/fontconfig
	media-libs/freetype
	media-libs/harfbuzz
	media-libs/libglvnd[X]
	media-libs/libpng
	net-dns/libidn2
	net-libs/gnutls
	net-libs/libproxy
	net-print/cups
	sys-apps/dbus
	sys-apps/systemd-utils
	sys-apps/util-linux
	sys-devel/gcc
	sys-libs/glibc
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libxcb
	x11-libs/libxkbcommon
	virtual/zlib
"

QA_PREBUILT="opt/${PN}/masterpdfeditor5"

src_install() {
	insinto /opt/${MyPN}
	doins -r fonts icc_profiles lang stamps templates masterpdfeditor5.png
	exeinto /opt/${MyPN}
	doexe masterpdfeditor5
	exeinto /opt/bin
	doexe "${FILESDIR}"/mpe5
	domenu masterpdfeditor5.desktop
	for s in 16 32 64 96 128 256
	do doicon -s ${s} ${s}x${s}/apps/masterpdfeditor5.png
	done
}

pkg_postinst() {
	xdg_pkg_postinst
}

pkg_postrm() {
	xdg_pkg_postrm
}
