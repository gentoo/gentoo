# Copyright 2018-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib

DESCRIPTION="Secure Reliable Transport (SRT) library and tools"
HOMEPAGE="https://github.com/Haivision/srt"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/Haivision/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Haivision/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 -sparc ~x86 ~ppc-macos ~x64-macos ~x86-macos"
fi

LICENSE="MPL-2.0"
SLOT="0"
IUSE="gnutls libressl test"

RDEPEND="
	gnutls? (
		dev-libs/nettle:0=[${MULTILIB_USEDEP}]
		net-libs/gnutls:0=[${MULTILIB_USEDEP}]
	)
	!gnutls? (
		!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${RDEPEND}
	test? ( dev-cpp/gtest )
"

RESTRICT="!test? ( test )"

PATCHES=(
	"${FILESDIR}/${PN}-always-GNUInstallDirs.patch"
)

src_prepare() {
	cmake-utils_src_prepare
	sed -i -e "s:hcrypt_ut.c::" haicrypt/*.maf || die
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_STATIC=OFF
		-DUSE_GNUTLS=$(usex gnutls)
		-DENABLE_UNITTESTS=$(usex test)
	)
	cmake-multilib_src_configure
}
