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
	if [[ "${PV}" == *_beta* ]] ; then
		SRC_URI="https://github.com/keepassxreboot/${PN}/archive/${PV/_/-}.tar.gz
			-> ${P}.gh.tar.gz"
		S="${WORKDIR}/${P/_/-}"
	else
		# switch to QT6 porting branch
		# https://github.com/varjolintu/keepassxc/tree/qt6_ver2
		GIT_HASH="216097f5c701579b9a86ff34e20a37800495f2f3"
		SRC_URI="https://github.com/varjolintu/keepassxc/archive/${GIT_HASH}.tar.gz
			-> ${P}.${GIT_HASH}.qt6.tar.gz"
		S="${WORKDIR}/${PN}-${GIT_HASH}"
	fi
	# remove keywords for this development branch
	# KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
fi

# COPYING order
LICENSE="|| ( GPL-2 GPL-3 ) BSD LGPL-2.1 MIT LGPL-2 CC0-1.0 Apache-2.0 GPL-2+ BSD-2"
SLOT="0"
IUSE="X browser doc +keyring +network +ssh-agent test"

RESTRICT="!test? ( test )"

RDEPEND="
	app-crypt/argon2:=
	dev-libs/botan:3=
	dev-libs/libusb:1
	dev-libs/zxcvbn-c
	dev-qt/qtbase:6
	dev-qt/qtsvg:6
	dev-qt/qt5compat
	media-gfx/qrencode:=
	sys-apps/pcsc-lite
	sys-apps/keyutils
	sys-libs/readline:0=
	virtual/minizip:=
	virtual/zlib:=
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
BDEPEND="
	dev-qt/qttools:6[linguist]
	doc? (
		dev-ruby/asciidoctor
	)
"

PATCHES=(
	"${FILESDIR}/${PN}-2.8.0-cmake_minimum.patch"
	"${FILESDIR}/${PN}-2.7.10-tests.patch"
	"${FILESDIR}/${PN}-2.7.10-zxcvbn.patch"
)

src_prepare() {
	if ! [[ "${PV}" =~ _beta|9999 ]]; then
		echo "${PV}" > .version || die
	fi

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

	if [[ "${PV}" == *_beta* ]] ; then
		mycmakeargs+=(
			-DOVERRIDE_VERSION="${PV/_/-}"
		)
	fi

	cmake_src_configure
}
