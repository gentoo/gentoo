# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MULTILIB_COMPAT=( abi_x86_64 )

inherit chromium-2 desktop pax-utils unpacker multilib-build xdg

DESCRIPTION="Instant messaging client, with support for audio and video"
HOMEPAGE="https://www.skype.com/"
SRC_URI="https://repo.skype.com/deb/pool/main/s/skypeforlinux/${PN}_${PV}_amd64.deb"
S="${WORKDIR}"

LICENSE="Skype-TOS MIT MIT-with-advertising BSD-1 BSD-2 BSD Apache-2.0 Boost-1.0 ISC CC-BY-SA-3.0 CC0-1.0 openssl ZLIB APSL-2 icu Artistic-2 LGPL-2.1"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="selinux"

QA_PREBUILT="*"
RESTRICT="mirror bindist strip" #299368

RDEPEND="
	app-crypt/libsecret[${MULTILIB_USEDEP}]
	app-accessibility/at-spi2-core:2[${MULTILIB_USEDEP}]
	dev-libs/expat[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/nspr[${MULTILIB_USEDEP}]
	dev-libs/nss[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	media-libs/fontconfig:1.0[${MULTILIB_USEDEP}]
	media-libs/freetype:2[${MULTILIB_USEDEP}]
	media-libs/libv4l[${MULTILIB_USEDEP}]
	net-print/cups[${MULTILIB_USEDEP}]
	sys-apps/dbus[${MULTILIB_USEDEP}]
	sys-devel/gcc[cxx]
	sys-libs/glibc
	virtual/ttf-fonts
	x11-libs/cairo[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	x11-libs/gtk+:3[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libXScrnSaver[${MULTILIB_USEDEP}]
	x11-libs/libXcomposite[${MULTILIB_USEDEP}]
	x11-libs/libXcursor[${MULTILIB_USEDEP}]
	x11-libs/libXdamage[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libXi[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libXrender[${MULTILIB_USEDEP}]
	x11-libs/libXtst[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
	x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
	x11-libs/libxkbfile[${MULTILIB_USEDEP}]
	x11-libs/pango[${MULTILIB_USEDEP}]
	selinux? ( sec-policy/selinux-skype )
"

pkg_setup() {
	chromium_suid_sandbox_check_kernel_config
}

src_unpack() {
	unpack_deb ${A}
}

src_prepare() {
	default
	sed -e "s!^SKYPE_PATH=.*!SKYPE_PATH=${EPREFIX}/opt/skypeforlinux/skypeforlinux!" \
		-i usr/bin/skypeforlinux || die
	sed -e "s!^Categories=.*!Categories=Network;InstantMessaging;Telephony;!" \
		-e "/^OnlyShowIn=/d" \
		-i usr/share/applications/skypeforlinux.desktop || die
}

src_install() {
	dodir /opt
	cp -a usr/share/skypeforlinux "${ED}"/opt || die

	# remove chrome-sandbox binary, users should use kernel namespaces
	# https://bugs.gentoo.org/692692#c18
	rm "${ED}"/opt/skypeforlinux/chrome-sandbox || die

	dobin usr/bin/skypeforlinux

	dodoc usr/share/skypeforlinux/*.html
	dodoc -r usr/share/doc/skypeforlinux/.
	# symlink required for the "Help->3rd Party Notes" menu entry  (otherwise frozen skype -> xdg-open)
	dosym ${PF} usr/share/doc/skypeforlinux

	doicon usr/share/pixmaps/skypeforlinux.png

	local res
	for res in 16 32 256 512; do
		newicon -s ${res} usr/share/icons/hicolor/${res}x${res}/apps/skypeforlinux.png skypeforlinux.png
	done

	domenu usr/share/applications/skypeforlinux.desktop

	pax-mark -m "${ED}"/opt/skypeforlinux/skypeforlinux
	pax-mark -m "${ED}"/opt/skypeforlinux/resources/app.asar.unpacked/node_modules/slimcore/bin/slimcore.node
}
