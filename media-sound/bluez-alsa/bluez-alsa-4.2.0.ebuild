# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools bash-completion-r1 multilib-minimal readme.gentoo-r1 systemd

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
IUSE="aac aptx debug hcitop lame ldac liblc3 man mpg123 ofono static-libs systemd test unwind upower"

RESTRICT="!test? ( test )"

# bluez-alsa does not directly link to upower but
# is using the upower interface via dbus calls.
RDEPEND="
	>=dev-libs/glib-2.58.2[${MULTILIB_USEDEP}]
	>=media-libs/alsa-lib-1.1.2[${MULTILIB_USEDEP}]
	>=media-libs/sbc-1.5[${MULTILIB_USEDEP}]
	>=net-wireless/bluez-5.51[${MULTILIB_USEDEP}]
	sys-apps/dbus[${MULTILIB_USEDEP}]
	sys-libs/readline:0=
	aac? ( >=media-libs/fdk-aac-0.1.1:=[${MULTILIB_USEDEP}] )
	aptx? ( >=media-libs/libfreeaptx-0.1.1 )
	hcitop? (
		dev-libs/libbsd
		sys-libs/ncurses:0=
	)
	lame? ( media-sound/lame[${MULTILIB_USEDEP}] )
	ldac? ( >=media-libs/libldac-2.0.0 )
	liblc3? ( >=media-sound/liblc3-1.0.0 )
	mpg123? ( media-sound/mpg123[${MULTILIB_USEDEP}] )
	ofono? ( net-misc/ofono )
	systemd? ( sys-apps/systemd )
	unwind? ( sys-libs/libunwind[${MULTILIB_USEDEP}] )
	upower? ( sys-power/upower )
"
DEPEND="${RDEPEND}
	test? (
		>=dev-libs/check-0.11.0
		media-libs/libsndfile
	)
"
BDEPEND="
	dev-util/gdbus-codegen
	virtual/pkgconfig
	man? ( virtual/pandoc )
"

PATCHES=(
	"${FILESDIR}/${P}-fix-include-freeaptx.patch"
	# https://github.com/arkq/bluez-alsa/issues/718
	"${FILESDIR}/${P}-test-alsa-midi-checkdev.patch"
	# https://github.com/arkq/bluez-alsa/issues/717
	"${FILESDIR}/${P}-ldpreload.patch"
)

DOC_CONTENTS="Users can use this service when they are members of the \"audio\" group."

src_prepare() {
	default
	eautoreconf
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-cli
		--enable-faststream
		--enable-midi
		--enable-rfcomm
		--with-bash-completion="$(get_bashcompdir)"
		$(use_enable aac)
		$(use_enable debug)
		$(use_enable lame mp3lame)
		$(use_enable man manpages)
		$(use_enable mpg123)
		$(use_enable static-libs static)
		$(use_enable systemd)
		$(use_enable test)
		$(use_with systemd systemdsystemunitdir $(systemd_get_systemunitdir))
		$(multilib_native_use_enable aptx)
		$(multilib_native_use_enable aptx aptx-hd)
		$(multilib_native_use_with aptx libfreeaptx)
		$(multilib_native_use_enable hcitop)
		$(multilib_native_use_enable ldac)
		$(multilib_native_use_enable liblc3 lc3-swb)
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
	newconfd "${FILESDIR}"/bluealsa-conf.d-2-r1 bluealsa

	# Add config file to alsa datadir as well to preserve changes in /etc
	insinto "/usr/share/alsa/alsa.conf.d/"
	doins "src/asound/20-bluealsa.conf.in"

	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
