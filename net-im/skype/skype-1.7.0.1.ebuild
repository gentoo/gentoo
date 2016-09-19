# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

#inherit eutils rpm pax-utils
inherit eutils rpm

DESCRIPTION="P2P Internet Telephony (VoiceIP) client"
HOMEPAGE="http://www.skype.com/"
SRC_URI="https://repo.skype.com/rpm/stable/skypeforlinux_${PV}-1.x86_64.rpm"

LICENSE="Skype-TOS no-source-code"
SLOT="1"
KEYWORDS="~amd64 ~x86"
#IUSE="pax_kernel selinux"
IUSE=""

S="${WORKDIR}"
QA_PREBUILT=opt/skypeforlinux/skypeforlinux
RESTRICT="mirror bindist strip" #299368

RDEPEND="
	!${CATEGORY}/${PN}:0
	virtual/ttf-fonts
	gnome-base/libgnome-keyring
	gnome-base/gnome-keyring
	gnome-base/gconf"
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
