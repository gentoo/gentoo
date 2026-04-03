# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg

DESCRIPTION="KeePassXC - KeePass Cross-platform Community Edition"
HOMEPAGE="https://keepassxc.org"

#
# Experimental KeepassXC version with Qt6 support
#
# This version is based on the current upstream development branch and a
# patchset extracted from https://github.com/keepassxreboot/keepassxc/pull/11651
#
# Unkeyworded for the time being.
#
# Last commit on development repository:
#     commit 379be00127db60b1ddee9c67f4bfc49c15db8236
#     Author: Jonathan White <support@dmapps.us>
#     Date:   Sat Mar 14 19:21:44 2026 -0400
#
# Patch based on https://github.com/keepassxreboot/keepassxc/pull/11651 :
#     commit f93bfe5e036f9c0aafe78b08f189943ba31a9158 (HEAD -> qt6_ver2)
#     Author: Jonathan White <support@dmapps.us>
#     Date:   Sun Mar 15 22:23:06 2026 -0400
#

GIT_HASH="379be00127db60b1ddee9c67f4bfc49c15db8236"
PATCH_GIT_HASH="f93bfe5e036f9c0aafe78b08f189943ba31a9158"
SRC_URI="
	https://github.com/keepassxreboot/keepassxc/archive/${GIT_HASH}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~tamiko/distfiles/${P}-qt6_patches-${PATCH_GIT_HASH}.patch.gz"

S="${WORKDIR}/${PN}-${GIT_HASH}"

#  if [[ "${PV}" = *9999* ]] ; then
#      inherit git-r3
#
#      EGIT_BRANCH="develop"
#      EGIT_REPO_URI="https://github.com/keepassxreboot/${PN}"
#  else
#      if [[ "${PV}" == *_beta* ]] ; then
#          SRC_URI="https://github.com/keepassxreboot/${PN}/archive/${PV/_/-}.tar.gz
#              -> ${P}.gh.tar.gz"
#          S="${WORKDIR}/${P/_/-}"
#      else
#          SRC_URI="https://github.com/keepassxreboot/${PN}/archive/${PV}.tar.gz
#              -> ${P}.gh.tar.gz"
#      fi
#
#      KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
#  fi

# COPYING order
LICENSE="|| ( GPL-2 GPL-3 ) BSD LGPL-2.1 MIT LGPL-2 CC0-1.0 Apache-2.0 GPL-2+ BSD-2"
SLOT="0"
IUSE="X browser doc +keyring +network +ssh-agent test"

RESTRICT="!test? ( test )"

# Include path changed in zxcvbn-c-2.6
RDEPEND="
	app-crypt/argon2:=
	dev-libs/botan:3=
	dev-libs/libusb:1
	>=dev-libs/zxcvbn-c-2.6
	dev-qt/qtbase:6
	dev-qt/qtsvg:6
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

	"${WORKDIR}/${P}-qt6_patches-${PATCH_GIT_HASH}.patch"
	"${FILESDIR}/${PN}-2.8.0-cmake_minimum.patch"
	"${FILESDIR}/${PN}-2.7.10-tests.patch"
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
