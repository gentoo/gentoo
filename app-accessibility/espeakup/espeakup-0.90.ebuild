# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} == "9999" ]] ; then
	EGIT_REPO_URI="https://github.com/williamh/espeakup.git"
	inherit git-r3
else
	SRC_URI="https://github.com/linux-speakup/espeakup/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

inherit linux-info meson

DESCRIPTION="espeakup is a small lightweight connector for espeak and speakup"
HOMEPAGE="https://github.com/williamh/espeakup"

LICENSE="GPL-3"
SLOT="0"
IUSE="man systemd"

COMMON_DEPEND="app-accessibility/espeak-ng[sound]
	media-libs/alsa-lib"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"
BDEPEND="man? ( app-text/ronn )"

CONFIG_CHECK="~SPEAKUP ~SPEAKUP_SYNTH_SOFT"
ERROR_SPEAKUP="CONFIG_SPEAKUP is not enabled in this kernel!"
ERROR_SPEAKUP_SYNTH_SOFT="CONFIG_SPEAKUP_SYNTH_SOFT is not enabled in this kernel!"

src_configure() {
	local emesonargs
	emesonargs=(
		$(meson_feature man)
		$(meson_feature systemd)
		)
	meson_src_configure
}

src_install() {
	meson_src_install
	einstalldocs
	newconfd "${FILESDIR}"/espeakup.confd espeakup
	newinitd "${FILESDIR}"/espeakup.initd espeakup
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
