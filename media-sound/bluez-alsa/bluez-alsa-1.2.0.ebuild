# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils multilib-minimal

DESCRIPTION="Bluetooth Audio ALSA Backend"
HOMEPAGE="https://github.com/Arkq/bluez-alsa"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Arkq/${PN}"
else
	SRC_URI="https://github.com/Arkq/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="aac debug hcitop"

RDEPEND=">=dev-libs/glib-2.16[dbus,${MULTILIB_USEDEP}]
	>=media-libs/alsa-lib-1.0[${MULTILIB_USEDEP}]
	>=media-libs/sbc-1.2[${MULTILIB_USEDEP}]
	>=net-wireless/bluez-5[${MULTILIB_USEDEP}]
	aac? ( >=media-libs/fdk-aac-0.1.1[${MULTILIB_USEDEP}] )
	hcitop? (
		dev-libs/libbsd
		sys-libs/ncurses:0=
	)"
DEPEND="${RDEPEND}
	net-libs/ortp
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		$(use_enable aac) \
		$(use_enable debug) \
		$(multilib_native_use_enable hcitop)
}

multilib_src_install_all() {
	default
	prune_libtool_files --modules

	newinitd "${FILESDIR}"/bluealsa-init.d bluealsa
	newconfd "${FILESDIR}"/bluealsa-conf.d bluealsa
}

pkg_postinst() {
	elog "Users can use this service when they are members of the \"audio\" group."
}
