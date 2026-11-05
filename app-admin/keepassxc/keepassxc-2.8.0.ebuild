# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="KeePassXC - KeePass Cross-platform Community Edition"
HOMEPAGE="https://keepassxc.org"

if [[ "${PV}" = *9999* ]] ; then
	inherit git-r3

	EGIT_BRANCH="develop"
	EGIT_REPO_URI="https://github.com/keepassxreboot/${PN}"
else
	inherit verify-sig

	MY_P="${PN}-${PV/_/-}"
	SRC_URI="
		https://github.com/keepassxreboot/${PN}/releases/download/${PV/_/-}/${MY_P}-src.tar.xz
		verify-sig? (
			https://github.com/keepassxreboot/${PN}/releases/download/${PV/_/-}/${MY_P}-src.tar.xz.sig
		)
	"
	S="${WORKDIR}/${MY_P}"

	KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"

	VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/keepassxc.asc
	BDEPEND="verify-sig? ( sec-keys/openpgp-keys-keepassxc )"
fi

# COPYING order
LICENSE="|| ( GPL-2 GPL-3 ) BSD LGPL-2.1 MIT LGPL-2 CC0-1.0 Apache-2.0 GPL-2+ BSD-2"
SLOT="0"
IUSE="X browser doc +keyring +network +ssh-agent test"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/botan:3=
	dev-libs/libusb:1
	>=dev-libs/zxcvbn-c-2.6
	dev-qt/qtbase:6[concurrent,dbus,network]
	dev-qt/qtsvg:6
	media-gfx/qrencode:=
	sys-apps/pcsc-lite
	sys-apps/keyutils:=
	sys-libs/readline:=
	virtual/minizip:=
	virtual/zlib:=
	x11-libs/libxkbcommon
	X? (
		dev-qt/qtbase:6[X]
		x11-libs/libXext
		x11-libs/libX11
		x11-libs/libXi
		x11-libs/libXtst
	)
"
DEPEND="
	${RDEPEND}
"
BDEPEND+="
	dev-qt/qttools:6[linguist]
	doc? (
		dev-ruby/asciidoctor
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.8.0-cmake_minimum.patch"
	"${FILESDIR}/${PN}-2.8.0-polkit-register-details.patch"
)

CMAKE_SKIP_TESTS=(
	testcli
)

src_prepare() {
	# Unbundle zxcvbn, bug 958062
	rm -r ./src/thirdparty/zxcvbn || die

	cmake_src_prepare
}

src_configure() {
	local -a mycmakeargs=(
		# Gentoo users enable ccache via e.g. FEATURES=ccache or
		# other means. We don't want the build system to enable it for us.
		-DWITH_CCACHE="OFF"
		-DWITH_GUI_TESTS="OFF"
		-DKPXC_FEATURE_UPDATES="OFF"

		-DWITH_TESTS="$(usex test)"
		-DKPXC_FEATURE_BROWSER="$(usex browser)"
		-DKPXC_FEATURE_DOCS="$(usex doc)"
		-DKPXC_FEATURE_FDOSECRETS="$(usex keyring)"
		-DKPXC_FEATURE_NETWORK="$(usex network)"
		-DKPXC_FEATURE_SSHAGENT="$(usex ssh-agent)"
		-DWITH_X11="$(usex X)"
	)

	cmake_src_configure
}

src_test() {
	# TLD wildcard checks are only built with KPXC_FEATURE_BROWSER
	use browser || CMAKE_SKIP_TESTS+=( testurltools )

	cmake_src_test
}
