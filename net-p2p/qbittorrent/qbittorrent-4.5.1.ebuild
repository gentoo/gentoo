# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multibuild systemd xdg

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
IUSE="+dbus +gui webui"
REQUIRED_USE="dbus? ( gui )
	|| ( gui webui )"

RDEPEND="
	dev-libs/boost:=
	>=dev-libs/openssl-1.1.1:=
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5
	dev-qt/qtxml:5
	<net-libs/libtorrent-rasterbar-2:=
	>=sys-libs/zlib-1.2.11
	dbus? ( dev-qt/qtdbus:5 )
	gui? (
		dev-libs/geoip
		dev-qt/qtgui:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
	)"
DEPEND="${RDEPEND}"
BDEPEND="dev-qt/linguist-tools:5
	virtual/pkgconfig"

DOCS=( AUTHORS Changelog CONTRIBUTING.md README.md )

src_prepare() {
	MULTIBUILD_VARIANTS=()
	use gui && MULTIBUILD_VARIANTS+=( gui )
	use webui && MULTIBUILD_VARIANTS+=( nogui )

	cmake_src_prepare
}

src_configure() {
	multibuild_src_configure() {
		local mycmakeargs=(
			# musl lacks execinfo.h
			-DSTACKTRACE=$(usex !elibc_musl)

			# More verbose build logs are preferable for bug reports
			-DVERBOSE_CONFIGURE=ON

			# Not yet in ::gentoo
			-DQT6=OFF

			-DWEBUI=$(usex webui)
		)

		if [[ ${MULTIBUILD_VARIANT} == gui ]]; then
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
				# The systemd service calls qbittorrent-nox, which is only
				# installed when GUI=OFF.
				-DSYSTEMD=ON
				-DSYSTEMD_SERVICES_INSTALL_DIR="$(systemd_get_systemunitdir)"
			)
		fi

		cmake_src_configure
	}

	multibuild_foreach_variant multibuild_src_configure
}

src_compile() {
	multibuild_foreach_variant cmake_src_compile
}

src_install() {
	multibuild_foreach_variant cmake_src_install
	einstalldocs
}
