# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/x11rdp/x11rdp-0.8.0.1.9.5.ebuild,v 1.2 2015/04/12 18:39:09 mgorny Exp $

EAPI=5

inherit flag-o-matic versionator

XRDP_P=xrdp-$(get_version_component_range 1-3)
XORG_P=xorg-server-$(get_version_component_range 4-6)

DESCRIPTION="A X11 server for RDP clients (used by xrdp)"
HOMEPAGE="http://www.xrdp.org/"
# mirrored from https://github.com/neutrinolabs/xrdp/releases
SRC_URI="http://dev.gentoo.org/~mgorny/dist/${XRDP_P}.tar.xz
	http://xorg.freedesktop.org/releases/individual/xserver/${XORG_P}.tar.bz2"

LICENSE="Apache-2.0 MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="nptl"

RDEPEND="dev-libs/openssl
	media-libs/freetype
	>=x11-apps/iceauth-1.0.2
	>=x11-apps/rgb-1.0.3
	>=x11-apps/xauth-1.0.3
	x11-apps/xkbcomp
	>=x11-libs/libpciaccess-0.10.3
	>=x11-libs/libXau-1.0.4
	>=x11-libs/libXdmcp-1.0.2
	>=x11-libs/libXfont-1.4.2
	>=x11-libs/libxkbfile-1.0.4
	>=x11-libs/pixman-0.15.20
	>=x11-libs/xtrans-1.2.2
	>=x11-misc/xbitmaps-1.0.1
	>=x11-misc/xkeyboard-config-1.4
	>=x11-libs/libX11-1.1.5
	>=x11-libs/libXext-1.0.5
	>=media-libs/mesa-7.8_rc[nptl=]
	<x11-base/xorg-server-1.17"

DEPEND="${RDEPEND}
	sys-devel/flex
	>=x11-proto/bigreqsproto-1.1.0
	>=x11-proto/compositeproto-0.4
	>=x11-proto/damageproto-1.1
	>=x11-proto/fixesproto-4.1
	>=x11-proto/fontsproto-2.0.2
	>=x11-proto/glproto-1.4.11
	>=x11-proto/inputproto-1.9.99.902
	>=x11-proto/kbproto-1.0.3
	>=x11-proto/randrproto-1.2.99.3
	>=x11-proto/recordproto-1.13.99.1
	>=x11-proto/renderproto-0.11
	>=x11-proto/resourceproto-1.0.2
	>=x11-proto/scrnsaverproto-1.1
	>=x11-proto/trapproto-3.4.3
	>=x11-proto/videoproto-2.2.2
	>=x11-proto/xcmiscproto-1.2.0
	>=x11-proto/xextproto-7.0.99.3
	>=x11-proto/xf86dgaproto-2.0.99.1
	>=x11-proto/xf86rushproto-1.1.2
	>=x11-proto/xf86vidmodeproto-2.2.99.1
	>=x11-proto/xineramaproto-1.1.3
	>=x11-proto/xproto-7.0.17
	>=x11-proto/xf86driproto-2.1.0
	>=x11-proto/dri2proto-2.3
	>=x11-libs/libdrm-2.4.20
	>=x11-apps/xinit-1.3"

# xrdp-specific
DEPEND="${DEPEND}
	app-arch/xz-utils"

S=${WORKDIR}/${XRDP_P}

src_prepare() {
	# -- xrdp patches --
	epatch "${FILESDIR}"/${XRDP_P}-0001-Include-xorg-list.h-to-fix-build-errors.patch
	epatch "${FILESDIR}"/${XRDP_P}-0002-Remove-dither-printing.patch

	# missing -pthread linking
	sed -i -e 's:LLIBS =:& -pthread:' xorg/X11R7.6/rdp/Makefile || die

	# -- xrdp fancy build layout --

	mv "${WORKDIR}/${XORG_P}" ./ || die
	mv "${S}"/xorg/X11R7.6/rdp "${XORG_P}/hw" || die
	ln -s ../.. "${XORG_P}/hw/build_dir" || die
	ln -s "${XORG_P}" xorg-server-1.9.3 || die

	# -- xorg-server patches --
	local xorg_patches=(
		"${FILESDIR}"/xorg-server-disable-acpi.patch
		"${FILESDIR}"/xorg-server-1.9-nouveau-default.patch
		"${FILESDIR}"/xorg-cve-2011-4028+4029.patch
		"${FILESDIR}"/xorg-server-1.9-cve-2013-1940.patch
		"${FILESDIR}"/xorg-server-1.9-cve-2013-4396.patch
	)
	cd "${XORG_P}" || die
	epatch "${xorg_patches[@]}"

	# -- stuff copied from xorg follows --

	# Xorg-server requires includes from OS mesa which are not visible for
	# users of binary drivers.
	# Due to the limitations of CONFIGURE_OPTIONS, we have to export this
	mkdir -p "${T}/mesa-symlinks/GL"
	for i in gl glx glxmd glxproto glxtokens; do
		ln -s "${EROOT}usr/$(get_libdir)/opengl/xorg-x11/include/$i.h" "${T}/mesa-symlinks/GL/$i.h" || die
	done
	for i in glext glxext; do
		ln -s "${EROOT}usr/$(get_libdir)/opengl/global/include/$i.h" "${T}/mesa-symlinks/GL/$i.h" || die
	done
	append-cppflags "-I${T}/mesa-symlinks"

	# (#121394) Causes window corruption
	filter-flags -fweb

	# Incompatible with GCC 3.x SSP on x86, bug #244352
	if use x86 ; then
		if [[ $(gcc-major-version) -lt 4 ]]; then
			filter-flags -fstack-protector
		fi
	fi

	# Incompatible with GCC 3.x CPP, bug #314615
	if [[ $(gcc-major-version) -lt 4 ]]; then
		ewarn "GCC 3.x C preprocessor may cause build failures. Use GCC 4.x"
		ewarn "or set CPP=cpp-4.3.4 (replace with the actual installed version)"
	fi
}

src_configure() {
	local myconf=(
		--disable-ipv6
		--disable-dmx
		--disable-kdrive
		--disable-kdrive-kbd
		--disable-kdrive-mouse
		--disable-kdrive-evdev
		--disable-tslib
		--disable-xcalibrate
		--enable-record
		--disable-xfree86-utils
		--disable-install-libxf86config
		--disable-dri
		--disable-dri2
		--enable-glx
		--disable-xnest
		--enable-xorg
		--disable-xvfb
		$(use_enable nptl glx-tls)
		--disable-config-udev
		--without-doxygen
		--without-xmlto
		--sysconfdir=/etc/X11
		--localstatedir=/var
		--enable-install-setuid
		--with-fontrootdir=/usr/share/fonts
		--with-xkb-output=/var/lib/xkb
		--disable-config-hal
		--without-dtrace
		--without-fop
		--with-os-vendor=Gentoo
		--with-sha1=libcrypto
	)

	# configure xorg-server, no need to configure xrdp
	cd "${XORG_P}" || die
	econf "${myconf[@]}"
}

src_compile() {
	# build xorg-server
	emake -C "${XORG_P}"

	# build x11rdp
	emake -C "${XORG_P}"/hw/rdp X11RDPBASE=/usr
}

src_install() {
	dobin "${XORG_P}"/hw/rdp/X11rdp
}
