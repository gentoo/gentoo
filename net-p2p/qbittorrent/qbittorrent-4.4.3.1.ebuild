# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake multibuild systemd xdg

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="https://www.qbittorrent.org
	  https://github.com/qbittorrent"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/qBittorrent.git"
else
	SRC_URI="https://github.com/qbittorrent/qBittorrent/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
	S="${WORKDIR}/qBittorrent-release-${PV}"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="+dbus +gui webui"
REQUIRED_USE="dbus? ( gui )
	|| ( gui webui )"

RDEPEND="
	>=dev-libs/boost-1.65.0-r1:=
	dev-libs/openssl:=
	dev-qt/qtcore:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5
	dev-qt/qtxml:5
	>=net-libs/libtorrent-rasterbar-1.2.14:=
	sys-libs/zlib
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

DOCS=( AUTHORS Changelog CONTRIBUTING.md README.md TODO )

src_prepare() {
	MULTIBUILD_VARIANTS=( base )
	use webui && MULTIBUILD_VARIANTS+=( webui )

	cmake_src_prepare
}

src_configure() {
	multibuild_src_configure() {
		local mycmakeargs=(
			-DDBUS=$(usex dbus)

			# musl lacks execinfo.h
			-DSTACKTRACE=$(usex !elibc_musl)

			# We always want to install unit files
			-DSYSTEMD=ON
			-DSYSTEMD_SERVICES_INSTALL_DIR=$(systemd_get_systemunitdir)

			# More verbose build logs are preferable for bug reports
			-DVERBOSE_CONFIGURE=ON

			# Not yet in ::gentoo
			-DQT6=OFF

			# We do these in multibuild, see bug #839531 for why.
			# Fedora has to do the same thing.
			-DGUI=$(usex gui)
		)

		if [[ ${MULTIBUILD_VARIANT} == webui ]] ; then
			mycmakeargs+=(
				-DGUI=OFF
				-DWEBUI=ON
			)
		else
			mycmakeargs+=( -DWEBUI=OFF )
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

	if ! use webui ; then
		# No || die deliberately as it doesn't always exist
		rm "${D}/$(systemd_get_systemunitdir)"/qbittorrent-nox*.service
	fi

	einstalldocs
}
