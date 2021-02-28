# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools multilib-minimal systemd

DESCRIPTION="Bluetooth Audio ALSA Backend"
HOMEPAGE="https://github.com/Arkq/bluez-alsa"

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Arkq/${PN}"
else
	SRC_URI="https://github.com/Arkq/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="aac debug hcitop lame ldac man mpg123 ofono static-libs test unwind upower"
RESTRICT="!test? ( test )"

# bluez-alsa does not directly link to upower but
# is using the upower interface via dbus calls.
RDEPEND="
	>=dev-libs/glib-2.26[${MULTILIB_USEDEP}]
	>=media-libs/alsa-lib-1.1.2[${MULTILIB_USEDEP}]
	>=media-libs/sbc-1.2[${MULTILIB_USEDEP}]
	>=net-wireless/bluez-5.0[${MULTILIB_USEDEP}]
	sys-apps/dbus[${MULTILIB_USEDEP}]
	sys-libs/readline:0=
	aac? ( >=media-libs/fdk-aac-0.1.1:=[${MULTILIB_USEDEP}] )
	lame? ( media-sound/lame[${MULTILIB_USEDEP}] )
	mpg123? ( media-sound/mpg123[${MULTILIB_USEDEP}] )
	hcitop? (
		dev-libs/libbsd
		sys-libs/ncurses:0=
	)
	ldac? ( >=media-libs/libldac-2.0.0 )
	ofono? ( net-misc/ofono )
	unwind? ( sys-libs/libunwind[${MULTILIB_USEDEP}] )
	upower? ( sys-power/upower )
"
DEPEND="${RDEPEND}
	test? ( dev-libs/check )"
BDEPEND="
	virtual/pkgconfig
	man? ( app-text/pandoc )
"

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-rfcomm
		$(use_enable aac)
		$(use_enable debug)
		$(use_enable lame mp3lame)
		$(use_enable man manpages)
		$(use_enable mpg123)
		$(use_enable static-libs static)
		$(use_enable test)
		$(multilib_native_use_enable hcitop)
		$(multilib_native_use_enable ldac)
		$(multilib_native_use_enable ofono)
		$(multilib_native_use_enable upower)
		$(use_with unwind libunwind)
	)
	ECONF_SOURCE="${S}" econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	default
	find "${ED}" -type f -name "*.la" -delete || die

	newinitd "${FILESDIR}"/bluealsa-init.d bluealsa
	newconfd "${FILESDIR}"/bluealsa-conf.d-2 bluealsa
	systemd_dounit "${FILESDIR}"/bluealsa.service

	# Add config file to alsa datadir as well to preserve changes in /etc
	insinto "/usr/share/alsa/alsa.conf.d/"
	doins "src/asound/20-bluealsa.conf"
}

pkg_postinst() {
	elog "Users can use this service when they are members of the \"audio\" group."
}
