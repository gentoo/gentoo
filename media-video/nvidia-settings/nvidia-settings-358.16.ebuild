# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="NVIDIA Linux X11 Settings Utility"
HOMEPAGE="http://www.nvidia.com/"
SRC_URI="ftp://download.nvidia.com/XFree86/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="-* ~amd64 ~x86 ~x86-fbsd"
IUSE="examples gtk3"

COMMON_DEPEND="
	x11-libs/gtk+:2
	gtk3? ( x11-libs/gtk+:3 )
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXxf86vm
	x11-libs/gdk-pixbuf[X]
	media-libs/mesa
	x11-libs/pango[X]
	x11-libs/libXv
	x11-libs/libXrandr
	dev-libs/glib:2
	dev-libs/jansson
	x11-libs/cairo
	>=x11-libs/libvdpau-1.0"

RDEPEND="${COMMON_DEPEND}
	x11-drivers/nvidia-drivers:0/358"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	x11-proto/xproto"

src_compile() {
	einfo "Building libXNVCtrl..."
	emake -C src/ \
		CC="$(tc-getCC)" \
		AR="$(tc-getAR)" \
		RANLIB="$(tc-getRANLIB)" \
		build-xnvctrl

	einfo "Building nvidia-settings..."
	emake -C src/ \
		CC="$(tc-getCC)" \
		LD="$(tc-getLD)" \
		STRIP_CMD="$(type -P true)" \
		NV_VERBOSE=1 \
		NV_USE_BUNDLED_LIBJANSSON=0 \
		NVML_AVAILABLE=0 \
		GTK3_AVAILABLE=$(usex gtk3 1 0)
}

src_install() {
	emake -C src/ DESTDIR="${D}" PREFIX=/usr NV_USE_BUNDLED_LIBJANSSON=0 GTK3_AVAILABLE=$(usex gtk3 1 0) install

	insinto /usr/$(get_libdir)
	doins src/libXNVCtrl/libXNVCtrl.a

	insinto /usr/include/NVCtrl
	doins src/libXNVCtrl/*.h

#	doicon doc/${PN}.png # Installed through nvidia-drivers
	make_desktop_entry ${PN} "NVIDIA X Server Settings" ${PN} Settings

	# bug 412569 - Installed through nvidia-drivers
#	rm -rf "${D}"/usr/share/man

	dodoc doc/*.txt

	if use examples; then
		docinto examples/
		dodoc samples/*.c
		dodoc samples/README
	fi
}
