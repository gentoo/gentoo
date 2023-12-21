# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo multibuild systemd xdg

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="https://www.qbittorrent.org"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/qbittorrent/qBittorrent.git"
	inherit git-r3
else
	SRC_URI="https://github.com/qbittorrent/qBittorrent/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"
	S="${WORKDIR}"/qBittorrent-release-${PV}
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+dbus +gui qt6 systemd test webui"
RESTRICT="!test? ( test )"
REQUIRED_USE="|| ( gui webui )"

RDEPEND="
	acct-group/qbittorrent
	acct-user/qbittorrent
	>=dev-libs/openssl-1.1.1:=
	>=net-libs/libtorrent-rasterbar-1.2.18:=
	>=sys-libs/zlib-1.2.11
	qt6? ( dev-qt/qtbase:6[network,ssl,sql,sqlite,xml] )
	!qt6? (
		dev-qt/qtcore:5
		dev-qt/qtnetwork:5[ssl]
		dev-qt/qtsql:5[sqlite]
		dev-qt/qtxml:5
	)
	gui? (
		!qt6? (
			dev-qt/qtgui:5
			dev-qt/qtsvg:5
			dev-qt/qtwidgets:5
			dbus? ( dev-qt/qtdbus:5 )
		)
		qt6? (
			dev-qt/qtbase:6[dbus?,gui,widgets]
			dev-qt/qtsvg:6
		)
	)"
DEPEND="
	${RDEPEND}
	dev-libs/boost
	test? (
		!qt6? ( dev-qt/qttest:5 )
	)"
BDEPEND="
	!qt6? ( dev-qt/linguist-tools:5 )
	qt6? ( dev-qt/qttools:6[linguist] )
	virtual/pkgconfig"

DOCS=( AUTHORS Changelog CONTRIBUTING.md README.md )

src_prepare() {
	MULTIBUILD_VARIANTS=()
	use gui && MULTIBUILD_VARIANTS+=( gui )
	use webui && MULTIBUILD_VARIANTS+=( nogui )

	cmake_src_prepare
}

src_configure() {
	my_src_configure() {
		local mycmakeargs=(
			# musl lacks execinfo.h
			-DSTACKTRACE=$(usex !elibc_musl)
			# More verbose build logs are preferable for bug reports
			-DVERBOSE_CONFIGURE=ON
			-DQT6=$(usex qt6)
			-DWEBUI=$(usex webui)
			-DTESTING=$(usex test)
		)

		if [[ ${MULTIBUILD_VARIANT} == "gui" ]]; then
			# We do this in multibuild, see bug #839531 for why.
			# Fedora has to do the same thing.
			mycmakeargs+=(
				-DGUI=ON
				-DDBUS=$(usex dbus)
				-DSYSTEMD=OFF
			)
		else
			mycmakeargs+=(
				-DGUI=OFF
				-DDBUS=OFF
			)

			use systemd && mycmakeargs+=(
				# The systemd service calls qbittorrent-nox, which is only
				# installed when GUI=OFF.
				-DSYSTEMD=ON
				-DSYSTEMD_SERVICES_INSTALL_DIR="$(systemd_get_systemunitdir)"
			)
		fi

		cmake_src_configure
	}

	multibuild_foreach_variant my_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_test() {
	my_src_test() {
		cd "${BUILD_DIR}"/test || die
		edo ctest .
	}

	multibuild_foreach_variant my_src_test
}

src_install() {
	multibuild_foreach_variant cmake_src_install
	einstalldocs

	newconfd "${FILESDIR}/${PN}.confd" "${PN}"
	newinitd "${FILESDIR}/${PN}.initd" "${PN}"
}
