# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MULTILIB_COMPAT=( abi_x86_64 )

inherit eutils pax-utils rpm multilib-build

DESCRIPTION="P2P Internet Telephony (VoiceIP) client"
HOMEPAGE="https://www.skype.com/"
SRC_URI="https://repo.skype.com/rpm/stable/${PN}_${PV}-1.x86_64.rpm"

LICENSE="Skype-TOS no-source-code"
SLOT="0"
KEYWORDS="~amd64"
IUSE="pax_kernel"

S="${WORKDIR}"
QA_PREBUILT=opt/skypeforlinux/skypeforlinux
RESTRICT="mirror bindist strip" #299368

RDEPEND="dev-libs/atk[${MULTILIB_USEDEP}]
	dev-libs/expat[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/nspr[${MULTILIB_USEDEP}]
	dev-libs/nss[${MULTILIB_USEDEP}]
	gnome-base/gconf:2[${MULTILIB_USEDEP}]
	gnome-base/libgnome-keyring[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	media-libs/fontconfig:1.0[${MULTILIB_USEDEP}]
	media-libs/freetype:2[${MULTILIB_USEDEP}]
	net-print/cups[${MULTILIB_USEDEP}]
	sys-apps/dbus[${MULTILIB_USEDEP}]
	sys-devel/gcc[cxx]
	sys-libs/glibc
	virtual/ttf-fonts
	x11-libs/cairo[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	x11-libs/gtk+:2[${MULTILIB_USEDEP}]
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
	x11-libs/pango[${MULTILIB_USEDEP}]"

src_unpack() {
	rpm_src_unpack ${A}
}

src_prepare() {
	default
	sed -e "s!^SKYPE_PATH=.*!SKYPE_PATH=${EPREFIX}/opt/skypeforlinux/skypeforlinux!" \
		-i usr/bin/skypeforlinux || die
	sed -e "s!^Exec=.*!Exec=${EPREFIX}/opt/bin/skypeforlinux!" \
		-e "s!^Categories=.*!Categories=Network;InstantMessaging;Telephony;!" \
		-i usr/share/applications/skypeforlinux.desktop || die
}

src_install() {
	insinto /opt/skypeforlinux/locales
	doins usr/share/skypeforlinux/locales/*.pak

	insinto /opt/skypeforlinux/resources/app.asar.unpacked/node_modules/keytar/build/Release
	doins usr/share/skypeforlinux/resources/app.asar.unpacked/node_modules/keytar/build/Release/keytar.node

	insinto /opt/skypeforlinux/resources
	doins usr/share/skypeforlinux/resources/*.asar

	insinto /opt/skypeforlinux
	doins usr/share/skypeforlinux/*.pak
	doins usr/share/skypeforlinux/*.bin
	doins usr/share/skypeforlinux/*.dat
	doins usr/share/skypeforlinux/version
	exeinto /opt/skypeforlinux
	doexe usr/share/skypeforlinux/*.so
	doexe usr/share/skypeforlinux/skypeforlinux

	into /opt
	dobin usr/bin/skypeforlinux

	dodoc -r usr/share/doc/skypeforlinux/.

	doicon usr/share/pixmaps/skypeforlinux.png

	local res
	for res in 16 32 256 512; do
		newicon -s ${res} usr/share/icons/hicolor/${res}x${res}/apps/skypeforlinux.png skypeforlinux.png
	done

	domenu usr/share/applications/skypeforlinux.desktop

	if use pax_kernel; then
		pax-mark -Cm "${ED%/}"/opt/skypeforlinux/skypeforlinux
		eqawarn "You have set USE=pax_kernel meaning that you intend to run"
		eqawarn "${PN} under a PaX enabled kernel. To do so, we must modify"
		eqawarn "the ${PN} binary itself and this *may* lead to breakage! If"
		eqawarn "you suspect that ${PN} is being broken by this modification,"
		eqawarn "please open a bug."
	fi
}
