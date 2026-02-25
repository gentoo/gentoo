# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake edo multibuild optfeature systemd verify-sig xdg

DESCRIPTION="BitTorrent client in C++ and Qt"
HOMEPAGE="https://www.qbittorrent.org"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/qbittorrent/qBittorrent.git"
	inherit git-r3
else
	SRC_URI="
		https://downloads.sourceforge.net/qbittorrent/${P}.tar.xz
		verify-sig? ( https://downloads.sourceforge.net/qbittorrent/${P}.tar.xz.asc )
	"
	KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~riscv ~x86"

	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-qbittorrent )"
	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/qBittorrent.asc
fi

LICENSE="GPL-2+-with-openssl-exception GPL-3+-with-openssl-exception"
SLOT="0"
IUSE="+dbus +gui test webui"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	|| ( gui webui )
	dbus? ( gui )
"

# boost is not linked, but we must rebuild when libtorrent-rasterbar does.
# See bug #969055
RDEPEND="
	>=dev-libs/boost-1.76:=
	>=dev-libs/openssl-3.0.2:=
	>=dev-qt/qtbase-6.5:6[network,ssl,sql,sqlite,xml]
	>=net-libs/libtorrent-rasterbar-2.0.10:=
	>=virtual/zlib-1.2.11:=
	gui? (
		>=dev-qt/qtbase-6.5:6[dbus?,gui,widgets]
		>=dev-qt/qtsvg-6.5:6
	)
	webui? (
		acct-group/qbittorrent
		acct-user/qbittorrent
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND+="
	>=dev-qt/qttools-6.5:6[linguist]
	virtual/pkgconfig
"

DOCS=( AUTHORS Changelog {CONTRIBUTING,README}.md )

src_configure() {
	MULTIBUILD_VARIANTS=(
		$(usev gui)
		$(usev webui nogui)
	)

	my_src_configure() {
		local mycmakeargs=(
			-DVERBOSE_CONFIGURE=ON # for bug reports
			-DSTACKTRACE=$(usex !elibc_musl) # musl lacks execinfo.h
			-DTESTING=$(usex test)
			-DWEBUI=$(usex webui)
		)

		# upstream supports building just gui or nogui
		# so we build the project twice (see #839531 for details)
		# Fedora does the same: https://src.fedoraproject.org/rpms/qbittorrent
		if [[ ${MULTIBUILD_VARIANT} == "gui" ]]; then
			mycmakeargs+=(
				-DGUI=ON
				-DDBUS=$(usex dbus)
				-DSYSTEMD=OFF
			)
		else
			mycmakeargs+=(
				-DGUI=OFF
				-DDBUS=OFF
				# The systemd service calls qbittorrent-nox, built only when GUI=OFF.
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
		# cmake does not detect tests by default, if you use enable_testing
		# in a subdirectory instead of the root CMakeLists.txt
		cd "${BUILD_DIR}"/test || die
		edo ctest .
	}

	multibuild_foreach_variant my_src_test
}

src_install() {
	multibuild_foreach_variant cmake_src_install

	if use webui; then
		newconfd "${FILESDIR}/${PN}.confd" "${PN}"
		newinitd "${FILESDIR}/${PN}.initd" "${PN}"
	fi
}

pkg_postinst() {
	xdg_pkg_postinst

	optfeature "I2P anonymyzing network support" net-vpn/i2pd net-vpn/i2p
}
