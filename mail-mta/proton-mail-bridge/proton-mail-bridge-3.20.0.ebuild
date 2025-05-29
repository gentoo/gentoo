# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop go-env go-module systemd xdg-utils

MY_PN="${PN/-mail/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Serves Proton Mail to IMAP/SMTP clients"
HOMEPAGE="https://proton.me/mail/bridge https://github.com/ProtonMail/proton-bridge/"
SRC_URI="https://github.com/ProtonMail/${MY_PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI+=" https://dev.gentoo.org/~expeditioneer/distfiles/${CATEGORY}/${PN}/${P}-vendor.tar.xz"
S="${WORKDIR}"/${MY_P}

LICENSE="Apache-2.0 BSD BSD-2 GPL-3+ ISC LGPL-3+ MIT MPL-2.0 Unlicense"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gui"

# Quite a few tests require Internet access
PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="
	app-crypt/libsecret
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
	"${FILESDIR}"/${PN}-3.15.1-gui_gentoo.patch
)

src_unpack() {
	default

	if [[ -d "${WORKDIR}"/vendor ]]; then # if we ship the dependencies
		mv "${WORKDIR}"/vendor "${S}"/vendor || die # move them into the tree
	fi

	go-env_set_compile_environment
}

src_prepare() {
	xdg_environment_reset
	default
	if use gui; then
		# prepare desktop file
		local desktopFilePath="${S}"/dist/${MY_PN}.desktop
		sed -i 's/protonmail/proton-mail/g' ${desktopFilePath} || die
		sed -i 's/Exec=proton-mail-bridge/Exec=proton-mail-bridge-gui/g' ${desktopFilePath} || die

		# build GUI
		local PATCHES=()
		BUILD_DIR="${WORKDIR}"/gui_build \
			CMAKE_USE_DIR="${S}"/internal/frontend/bridge-gui/bridge-gui \
			cmake_src_prepare
	fi
}

src_configure() {
	if use gui; then
		local mycmakeargs=(
			-DBRIDGE_APP_FULL_NAME="Proton Mail Bridge"
			-DBRIDGE_APP_VERSION="${PV}+git"
			-DBRIDGE_REPO_ROOT="${S}"
			-DBRIDGE_TAG="NOTAG"
			-DBRIDGE_VENDOR="Gentoo Linux"
			-DCMAKE_DISABLE_PRECOMPILE_HEADERS=OFF
		)
		BUILD_DIR="${WORKDIR}"/gui_build \
			CMAKE_USE_DIR="${S}"/internal/frontend/bridge-gui/bridge-gui \
			cmake_src_configure
	fi
}

src_compile() {
	emake -Onone build-nogui

	if use gui; then
		BUILD_DIR="${WORKDIR}"/gui_build \
			CMAKE_USE_DIR="${S}"/internal/frontend/bridge-gui/bridge-gui \
			cmake_src_compile
	fi
}

src_test() {
	emake -Onone test
}

src_install() {
	exeinto /usr/bin
	newexe bridge ${PN}

	if use gui; then
		BUILD_DIR="${WORKDIR}"/gui_build \
			CMAKE_USE_DIR="${S}"/internal/frontend/bridge-gui/bridge-gui \
			cmake_src_install
		mv "${ED}"/usr/bin/bridge-gui "${ED}"/usr/bin/${PN}-gui || die
		newicon {"${S}"/dist/bridge,${PN}}.svg
		newmenu {dist/${MY_PN},${PN}}.desktop
	fi

	systemd_newuserunit "${FILESDIR}"/${PN}.service-r1 ${PN}.service

	einstalldocs
}
