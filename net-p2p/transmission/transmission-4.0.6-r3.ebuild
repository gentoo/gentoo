# Copyright 2006-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic tmpfiles systemd xdg-utils

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/transmission/transmission"
else
	MY_PV="${PV/_beta/-beta.}"
	MY_P="${PN}-${MY_PV}"
	S="${WORKDIR}/${MY_P}"
	SRC_URI="https://github.com/transmission/transmission/releases/download/${MY_PV}/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
fi

DESCRIPTION="A fast, easy, and free BitTorrent client"
HOMEPAGE="https://transmissionbt.com/"

# web/LICENSE is always GPL-2 whereas COPYING allows either GPL-2 or GPL-3 for the rest
# transmission in licenses/ is for mentioning OpenSSL linking exception
# MIT is in several libtransmission/ headers
LICENSE="|| ( GPL-2 GPL-3 Transmission-OpenSSL-exception ) GPL-2 MIT"
SLOT="0"
IUSE="appindicator cli debug gtk nls mbedtls qt5 qt6 systemd test"
REQUIRED_USE="?? ( qt5 qt6 )"
RESTRICT="!test? ( test )"

ACCT_DEPEND="
	acct-group/transmission
	acct-user/transmission
"
BDEPEND="
	virtual/pkgconfig
	nls? (
		gtk? ( sys-devel/gettext )
	)
	qt5? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
"
COMMON_DEPEND="
	app-arch/libdeflate:=
	>=dev-libs/libevent-2.1.0:=[threads(+)]
	!mbedtls? ( dev-libs/openssl:0= )
	mbedtls? ( net-libs/mbedtls:0= )
	net-libs/libnatpmp
	>=net-libs/libpsl-0.21.1
	>=net-libs/miniupnpc-1.7:=
	>=net-misc/curl-7.28.0[ssl]
	sys-libs/zlib:=
	nls? ( virtual/libintl )
	gtk? (
		>=dev-cpp/gtkmm-4.11.1:4.0
		>=dev-cpp/glibmm-2.60.0:2.68
		appindicator? ( dev-libs/libayatana-appindicator )
	)
	qt5? (
		dev-qt/qtcore:5
		dev-qt/qtdbus:5
		dev-qt/qtgui:5
		dev-qt/qtnetwork:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)
	qt6? (
		dev-qt/qtbase:6[dbus,gui,network,widgets]
		dev-qt/qtsvg:6
	)
	systemd? ( >=sys-apps/systemd-209:= )
"
DEPEND="${COMMON_DEPEND}
	nls? ( virtual/libintl )
"
RDEPEND="${COMMON_DEPEND}
	${ACCT_DEPEND}
"

PATCHES=(
	"${FILESDIR}/transmission-4.0.6-miniupnpc-2.2.8.patch"
)

src_configure() {
	local mycmakeargs=(
		-DCMAKE_INSTALL_DOCDIR=share/doc/${PF}

		-DENABLE_GTK=$(usex gtk ON OFF)
		-DENABLE_MAC=OFF
		-DREBUILD_WEB=OFF
		-DENABLE_CLI=$(usex cli ON OFF)
		-DENABLE_TESTS=$(usex test ON OFF)
		-DENABLE_NLS=$(usex nls ON OFF)

		-DRUN_CLANG_TIDY=OFF

		-DUSE_GTK_VERSION=4
		-DUSE_SYSTEM_EVENT2=ON
		-DUSE_SYSTEM_DEFLATE=ON
		-DUSE_SYSTEM_DHT=OFF
		-DUSE_SYSTEM_MINIUPNPC=ON
		-DUSE_SYSTEM_NATPMP=ON
		-DUSE_SYSTEM_UTP=OFF
		-DUSE_SYSTEM_B64=OFF
		-DUSE_SYSTEM_PSL=ON

		-DWITH_CRYPTO=$(usex mbedtls mbedtls openssl)
		-DWITH_INOTIFY=ON
		-DWITH_APPINDICATOR=$(usex appindicator ON OFF)
		-DWITH_SYSTEMD=$(usex systemd ON OFF)
	)

	if use qt6; then
		mycmakeargs+=( -DENABLE_QT=ON -DUSE_QT_VERSION=6 )
	elif use qt5; then
		mycmakeargs+=( -DENABLE_QT=ON -DUSE_QT_VERSION=5 )
	else
		mycmakeargs+=( -DENABLE_QT=OFF )
	fi

	# Disable assertions by default, bug 893870.
	use debug || append-cppflags -DNDEBUG

	cmake_src_configure
}

src_test() {
	# https://github.com/transmission/transmission/issues/4763
	cmake_src_test -E DhtTest.usesBootstrapFile
}

src_install() {
	cmake_src_install

	newinitd "${FILESDIR}"/transmission-daemon.initd.10 transmission-daemon
	newconfd "${FILESDIR}"/transmission-daemon.confd.4 transmission-daemon

	if use systemd; then
		# Service sets Type=notify
		systemd_dounit daemon/transmission-daemon.service
		systemd_install_serviced "${FILESDIR}"/transmission-daemon.service.conf
	fi

	insinto /usr/lib/sysctl.d
	doins "${FILESDIR}"/60-transmission.conf

	newtmpfiles "${FILESDIR}"/transmission-daemon.tmpfiles transmission-daemon.conf
}

pkg_postrm() {
	if use gtk || use qt5 || use qt6; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
}

pkg_postinst() {
	if use gtk || use qt5 || use qt6; then
		xdg_desktop_database_update
		xdg_icon_cache_update
	fi
	tmpfiles_process transmission-daemon.conf
}
