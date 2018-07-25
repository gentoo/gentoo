# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools multilib-minimal

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
IUSE="aac debug hcitop static-libs"

RDEPEND=">=dev-libs/glib-2.26[dbus,${MULTILIB_USEDEP}]
	>=media-libs/alsa-lib-1.0[${MULTILIB_USEDEP}]
	>=media-libs/sbc-1.2[${MULTILIB_USEDEP}]
	>=net-wireless/bluez-5.0[${MULTILIB_USEDEP}]
	aac? ( >=media-libs/fdk-aac-0.1.1[${MULTILIB_USEDEP}] )
	hcitop? (
		dev-libs/libbsd
		sys-libs/ncurses:0=
	)"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-rfcomm
		$(use_enable aac)
		$(use_enable debug)
		$(use_enable static-libs static)
		$(multilib_native_use_enable hcitop)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default
	find "${ED}" -name "*.la" -delete || die

	newinitd "${FILESDIR}"/bluealsa-init.d bluealsa
	newconfd "${FILESDIR}"/bluealsa-conf.d-2 bluealsa
}

pkg_postinst() {
	elog "Users can use this service when they are members of the \"audio\" group."
}
