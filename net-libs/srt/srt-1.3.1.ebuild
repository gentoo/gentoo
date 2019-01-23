# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

DESCRIPTION="Open-source implementation of the Secure Real-time Transport Protocol (SRTP)"
HOMEPAGE="https://github.com/Haivision/srt"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/Haivision/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Haivision/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 -sparc ~x86 ~x86-fbsd ~ppc-macos ~x64-macos ~x86-macos"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="doc libressl gnutls"

RDEPEND="
	gnutls? ( net-libs/gnutls )
	!gnutls? (
		!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
		libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
	)
"
DEPEND="${RDEPEND}"
DOCS=( README.md )

PATCHES=(
	"${FILESDIR}/${PN}-always-GNUInstallDirs.patch"
	"${FILESDIR}/${P}-no-rpath.patch"
	"${FILESDIR}/${P}-use-destdir-for-symlinks-09afc227e0880b12a98e18ee8182f89c3a80e3a6.patch"
)

src_prepare() {
	cmake-utils_src_prepare
	sed -i -e "s:hcrypt_ut.c::" "${S}"/haicrypt/*.maf || die
	sed -i -e 's:DESTINATION lib:DESTINATION lib${LIB_SUFFIX}:' CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-DUSE_GNUTLS=$(usex gnutls)
	)
	cmake-multilib_src_configure
}
