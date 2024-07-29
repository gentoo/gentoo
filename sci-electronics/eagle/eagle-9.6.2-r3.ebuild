# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop optfeature xdg

DESCRIPTION="Autodesk EAGLE schematic and printed circuit board (PCB) layout editor"
HOMEPAGE="https://www.autodesk.com/"
SRC_URI="https://eagle-updates.circuits.io/downloads/${PV//./_}/Autodesk_EAGLE_${PV}_English_Linux_64bit.tar.gz"

LICENSE="Autodesk"
SLOT="0"
KEYWORDS="-* amd64"

QA_PREBUILT="opt/${PN}/*"
RESTRICT="mirror bindist"

RDEPEND="
	app-crypt/mit-krb5
	dev-libs/expat
	dev-libs/glib
	dev-libs/libpcre
	dev-libs/nspr
	dev-libs/nss
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5
	dev-qt/qtpositioning:5
	dev-qt/qtprintsupport:5
	dev-qt/qtsvg:5
	dev-qt/qtwebchannel:5
	dev-qt/qtwebengine:5
	dev-qt/qtwidgets:5
	dev-qt/qtxml:5
	media-libs/alsa-lib
	media-libs/fontconfig
	media-libs/freetype
	media-libs/libglvnd
	media-libs/mesa
	net-dns/avahi
	net-print/cups
	sys-apps/dbus
	sys-apps/keyutils
	>=sys-fs/e2fsprogs-1.46.5
	sys-libs/glibc
	sys-libs/zlib
	x11-libs/libdrm
	x11-libs/libX11
	x11-libs/libXau
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxshmfence
	x11-libs/libXtst
"

src_prepare() {
	default
	# drop bundled ngpsice
	rm -r ngspice || die
	# drop bundled qt and other libs
	rm qt.conf || die
	rm -r resources plugins libexec || die
	# this libSuits.so(?) is not packaged anywhere in Gentoo so we keep it
	mv lib lib.back || die
	mkdir lib || die
	mv lib.back/libSuits.so lib/ || die
	rm -r lib.back || die
}

src_install() {
	dodoc doc/*.txt doc/*.pdf doc/ulp/*.pdf
	doman doc/eagle.1
	dodir /opt/${PN}

	# copy everything in
	cp -a "${S}/"* "${ED}/opt/${PN}/" || die
	fperms 0755 /opt/${PN}/${PN}
	# and make convenience symlink
	dosym "../${PN}/${PN}" "/opt/bin/${PN}"

	# Create desktop entry
	doicon -s 128x128 bin/${PN}-logo.png
	make_desktop_entry ${PN} "CadSoft EAGLE Layout Editor" ${PN}-logo "Graphics;Electronics"
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature 'SPICE circuit simulation support (set "Simulator Path" in Options -> Directories)' sci-electronics/ngspice
}
