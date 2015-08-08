# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit linux-info

DESCRIPTION="espeakup is a small lightweight connector for espeak and speakup"
HOMEPAGE="http://www.linux-speakup.org"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEPEND="|| (
	app-accessibility/espeak[portaudio]
	app-accessibility/espeak[pulseaudio] )"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

CONFIG_CHECK="~SPEAKUP ~SPEAKUP_SYNTH_SOFT"
ERROR_SPEAKUP="CONFIG_SPEAKUP is not enabled in this kernel!"
ERROR_SPEAKUP_SYNTH_SOFT="CONFIG_SPEAKUP_SYNTH_SOFT is not enabled in this kernel!"

pkg_setup() {
	if kernel_is -ge 2 6 37; then
		check_extra_config
	elif ! has_version app-accessibility/speakup; then
		ewarn "Cannot find speakup on your system."
		ewarn "Please upgrade your kernel to 2.6.37 or later and enable the"
		ewarn "CONFIG_SPEAKUP and CONFIG_SPEAKUP_SYNTH_SOFT options"
		ewarn "or install app-accessibility/speakup."
	fi
}

src_compile() {
	emake || die "Compile failed."
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed."
	dodoc ChangeLog README ToDo
	newconfd "${FILESDIR}"/espeakup.confd espeakup
	newinitd "${FILESDIR}"/espeakup.rc espeakup
}

pkg_postinst() {
	elog "To get espeakup to start automatically, it is currently recommended"
	elog "that you add it to the default run level, by giving the following"
	elog "command as root."
	elog
	elog "rc-update add espeakup default"
	elog
	elog "You can also set a default voice now for espeakup."
	elog "See /etc/conf.d/espeakup for how to do this."
}
