# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake go-module systemd xdg-utils

MY_PN="${PN/-mail/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Serves ProtonMail to IMAP/SMTP clients"
HOMEPAGE="https://proton.me/mail/bridge https://github.com/ProtonMail/proton-bridge/"
SRC_URI="https://github.com/ProtonMail/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~marecki/dists/${CATEGORY}/${PN}/${P}-deps.tar.xz"

LICENSE="Apache-2.0 BSD BSD-2 GPL-3+ ISC LGPL-3+ MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gui"

# Quite a few tests require Internet access
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="app-crypt/libsecret
	gui? (
		>=dev-libs/protobuf-21.12:=
		>=dev-libs/sentry-native-0.6.5-r1
		dev-qt/qtbase:6=[gui,icu,widgets]
		dev-qt/qtdeclarative:6=[widgets]
		dev-qt/qtsvg:6=
		media-libs/mesa
		net-libs/grpc:=
	)
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3.2-gui_gentoo.patch
)

S="${WORKDIR}"/${MY_P}

src_prepare() {
	xdg_environment_reset
	default
	if use gui; then
		local PATCHES=()
		BUILD_DIR="${WORKDIR}"/gui_build \
			CMAKE_USE_DIR="${S}"/internal/frontend/bridge-gui/bridge-gui \
			cmake_src_prepare
	fi
}

src_configure() {
	if use gui; then
		# TODO:
		#  - auto-sync version number between the two executables
		#  - can we leave BRIDGE_TAG unset? Seems it gets displayed in some info box
		local mycmakeargs=(
			-DBRIDGE_APP_FULL_NAME="Proton Mail Bridge"
			-DBRIDGE_APP_VERSION="${PV}+git"
			-DBRIDGE_REPO_ROOT="${S}"
			-DBRIDGE_TAG="NOTAG"
			-DBRIDGE_VENDOR="Gentoo Linux"
		)
		BUILD_DIR="${WORKDIR}"/gui_build \
			CMAKE_USE_DIR="${S}"/internal/frontend/bridge-gui/bridge-gui \
			cmake_src_configure
	fi
}

src_compile() {
	emake build-nogui

	if use gui; then
		BUILD_DIR="${WORKDIR}"/gui_build \
			CMAKE_USE_DIR="${S}"/internal/frontend/bridge-gui/bridge-gui \
			cmake_src_compile
	fi
}

src_test() {
	emake test
}

src_install() {
	exeinto /usr/bin
	newexe bridge ${PN}

	if use gui; then
		BUILD_DIR="${WORKDIR}"/gui_build \
			CMAKE_USE_DIR="${S}"/internal/frontend/bridge-gui/bridge-gui \
			cmake_src_install
		mv "${ED}"/usr/bin/bridge-gui "${ED}"/usr/bin/${PN}-gui || die
	fi

	systemd_newuserunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service

	einstalldocs
}

pkg_postinst() {
	if [[ -n "${REPLACING_VERSIONS}" ]]; then
		local oldver
		for oldver in ${REPLACING_VERSIONS}; do
			if ver_test "${oldver}" -lt 3.2.0; then
				ewarn "Please note that since version 3.2.0, ${PN} by default shares usage statistics with upstream."
				ewarn "For details, please see"
				ewarn
				ewarn "	https://proton.me/support/share-usage-statistics"
				ewarn
				ewarn "This behaviour can be disabled through ${PN}-gui, under Advanced Settings."
				ewarn
				break
			fi
		done
	fi
}
