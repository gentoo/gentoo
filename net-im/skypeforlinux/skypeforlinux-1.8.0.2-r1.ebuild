# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

#inherit eutils rpm pax-utils
inherit eutils rpm

DESCRIPTION="P2P Internet Telephony (VoiceIP) client"
HOMEPAGE="http://www.skype.com/"
SRC_URI="https://repo.skype.com/rpm/stable/skypeforlinux_${PV}-1.x86_64.rpm"

LICENSE="Skype-TOS no-source-code"
SLOT="0"
KEYWORDS="~amd64"
#IUSE="pax_kernel selinux"
IUSE=""

S="${WORKDIR}"
QA_PREBUILT=opt/skypeforlinux/skypeforlinux
RESTRICT="mirror bindist strip" #299368

RDEPEND="virtual/ttf-fonts
	!net-im/skype:1
	dev-libs/atk
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	gnome-base/gconf:2
	gnome-base/libgnome-keyring
	media-libs/alsa-lib
	media-libs/fontconfig:1.0
	media-libs/freetype:2
	net-print/cups
	sys-apps/dbus
	sys-devel/gcc
	sys-libs/glibc
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:2
	x11-libs/libX11
	x11-libs/libXcomposite
	x11-libs/libXcursor
	x11-libs/libXdamage
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libXScrnSaver
	x11-libs/libXtst
	x11-libs/pango"
#	selinux? ( sec-policy/selinux-skype )"

src_unpack () {
	rpm_src_unpack ${A}
}

src_prepare() {
	sed -e "s!^SKYPE_PATH=.*!SKYPE_PATH=${EROOT}opt/skypeforlinux/skypeforlinux!" \
		-i usr/bin/skypeforlinux
	sed -e "s!^Exec=.*!Exec=${EROOT}opt/bin/skypeforlinux!" \
		-e "s!^Categories=.*!Categories=Network;InstantMessaging;Telephony;!" \
		-i usr/share/applications/skypeforlinux.desktop
	eapply_user
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
	fowners root:audio /opt/bin/skypeforlinux /opt/skypeforlinux/skypeforlinux

#	insinto /etc/dbus-1/system.d
#	doins ${PN}.conf

	dodoc usr/share/doc/skypeforlinux/* usr/share/skypeforlinux/*.html
	dodoc usr/share/skypeforlinux/*.txt usr/share/skypeforlinux/LICENSE

	# create compat symlink
	dosym ${P} /usr/share/doc/skypeforlinux

	doicon usr/share/pixmaps/skypeforlinux.png

	local res
	for res in 16 32 256 512; do
		newicon -s ${res} usr/share/icons/hicolor/${res}x${res}/apps/skypeforlinux.png skypeforlinux.png
	done

	domenu usr/share/applications/skypeforlinux.desktop

#	if use pax_kernel; then
#		if use apulse; then
#			pax-mark Cm "${ED}"/opt/bin/${PN}-bin || die
#		else
#			pax-mark Cm "${ED}"/opt/bin/${PN} || die
#		fi
#		eqawarn "You have set USE=pax_kernel meaning that you intend to run"
#		eqawarn "${PN} under a PaX enabled kernel. To do so, we must modify"
#		eqawarn "the ${PN} binary itself and this *may* lead to breakage! If"
#		eqawarn "you suspect that ${PN} is being broken by this modification,"
#		eqawarn "please open a bug."
#	fi

#	echo PRELINK_PATH_MASK=/opt/bin/${PN} > ${T}/99${PN}
#	doenvd "${T}"/99${PN} #430142
}

pkg_postinst() {
	einfo "See https://support.skype.com/en/faq/FA34656"
	einfo "for more information about Skype for Linux Alpha."
}
