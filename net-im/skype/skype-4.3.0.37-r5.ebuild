# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils gnome2-utils pax-utils

DESCRIPTION="P2P Internet Telephony (VoiceIP) client"
HOMEPAGE="http://www.skype.com/"
SRC_URI="http://download.${PN}.com/linux/${P}.tar.bz2"

LICENSE="skype-4.0.0.7-copyright BSD MIT RSA W3C regexp-UofT no-source-code"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="apulse pax_kernel +pulseaudio selinux"
REQUIRED_USE="apulse? ( !pulseaudio )"

QA_PREBUILT=opt/bin/${PN}
RESTRICT="mirror bindist strip" #299368

EMUL_X86_VER=20120520

RDEPEND="
	virtual/ttf-fonts
	dev-qt/qtcore:4[abi_x86_32(-)]
	dev-qt/qtdbus:4[abi_x86_32(-)]
	dev-qt/qtgui:4[accessibility,abi_x86_32(-)]
	dev-qt/qtwebkit:4[abi_x86_32(-)]
	media-libs/alsa-lib[abi_x86_32(-)]
	x11-libs/libX11[abi_x86_32(-)]
	x11-libs/libXext[abi_x86_32(-)]
	x11-libs/libXScrnSaver[abi_x86_32(-)]
	x11-libs/libXv[abi_x86_32(-)]
	apulse? ( media-sound/apulse[abi_x86_32(-)] )
	pulseaudio? ( media-sound/pulseaudio[abi_x86_32(-)] )
	selinux? ( sec-policy/selinux-skype )"

src_prepare() {
	epatch "${FILESDIR}/${P}-desktop.patch"
}

src_compile() {
	if type -P lrelease >/dev/null; then
		lrelease lang/*.ts || die
	fi
	rm -f lang/*.ts || die
}

src_install() {

	if use apulse; then
		into /opt
		newbin ${PN} ${PN}-bin
		dobin "${FILESDIR}/${PN}"
		fowners root:audio /opt/bin/${PN} /opt/bin/${PN}-bin
	else
		into /opt
		dobin ${PN}
		fowners root:audio /opt/bin/${PN}
	fi

	insinto /etc/dbus-1/system.d
	doins ${PN}.conf

	insinto /usr/share/skype
	doins -r avatars lang sounds

	dodoc README

	local res
	for res in 16 32 48 64 96 128 256; do
		newicon -s ${res} icons/SkypeBlue_${res}x${res}.png ${PN}.png
	done

	domenu skype.desktop

	if use pax_kernel; then
		if use apulse; then
			pax-mark Cm "${ED}"/opt/bin/${PN}-bin || die
		else
			pax-mark Cm "${ED}"/opt/bin/${PN} || die
		fi
		eqawarn "You have set USE=pax_kernel meaning that you intend to run"
		eqawarn "${PN} under a PaX enabled kernel.  To do so, we must modify"
		eqawarn "the ${PN} binary itself and this *may* lead to breakage!  If"
		eqawarn "you suspect that ${PN} is being broken by this modification,"
		eqawarn "please open a bug."
	fi

	echo PRELINK_PATH_MASK=/opt/bin/${PN} > ${T}/99${PN}
	doenvd "${T}"/99${PN} #430142
}

pkg_preinst() {
	gnome2_icon_savelist

	rm -rf "${EROOT}"/usr/share/${PN} #421165
}

pkg_postinst() {
	gnome2_icon_cache_update

	# http://bugs.gentoo.org/360815
	elog "For webcam support, see \"LD_PRELOAD\" section of \"README.lib\" document provided by"
	elog "media-libs/libv4l package and \"README\" document of this package."

	if ! use pulseaudio && ! use apulse; then
		ewarn "ALSA support was removed from Skype"
		ewarn "consider installing media-sound/pulseaudio"
		ewarn "or media-sound/apulse for pulseaudio emulation"
		ewarn "otherwise sound will not work for you."
		ewarn "These packages can be pulled in by setting"
		ewarn "appropriate USE flags for net-im/skype."
	fi
}

pkg_postrm() {
	gnome2_icon_cache_update
}
