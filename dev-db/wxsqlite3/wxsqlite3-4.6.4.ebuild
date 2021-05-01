# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

WX_GTK_VER="3.0-gtk3"
DOCS_BUILDER="doxygen"
DOCS_DEPEND="app-doc/doxygen[clang]"
DOCS_DIR="docs"

inherit eutils multilib-minimal wxwidgets autotools docs

DESCRIPTION="C++ wrapper around the public domain SQLite 3.x database"
HOMEPAGE="http://utelle.github.io/wxsqlite3"
SRC_URI="https://github.com/utelle/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="wxWinLL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc debug aes128 aes256 chacha20 sqlcipher rc4"

DEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X,${MULTILIB_USEDEP}]
	>=dev-db/sqlite-3.34.0:3[${MULTILIB_USEDEP}]
	aes128? ( dev-db/sqlcipher[${MULTILIB_USEDEP}] ) 
	aes256? ( dev-db/sqlcipher[${MULTILIB_USEDEP}] ) 
	chacha20? ( dev-db/sqlcipher[${MULTILIB_USEDEP}] ) 
	sqlcipher? ( dev-db/sqlcipher[${MULTILIB_USEDEP}] ) 
	rc4? ( dev-db/sqlcipher[${MULTILIB_USEDEP}] ) 
	"

RDEPEND="${DEPEND}"

DOCS=( "readme.md" "samples/" )

PATCHES=(
	"${FILESDIR}"/${PN}-4.6.4-path-logo.patch
	"${FILESDIR}"/${PN}-4.6.4-remove-sample-program.patch
)

DOCS=( "readme.md" "samples/" )

src_prepare() {
	eautoreconf
	setup-wxwidgets
	default
	multilib_copy_sources
}

multilib_src_configure() {
	# set WX_CONFIG by ARCH
	setup-wxwidgets

	econf \
		--enable-shared \
		--with-wx-config="${WX_CONFIG}" \
		--disable-static \
		$(use_enable debug sqlite-debug) \
		$(usex aes128 --enable-codec=aes128 --without-aes128cbc) \
		$(usex aes256 --enable-codec=aes256 --without-aes256cbc) \
		$(usex chacha20 --enable-codec=chacha20 --without-chacha20) \
		$(usex sqlcipher --enable-codec=sqlcipher --without-sqlcipher) \
		$(usex rc4 --enable-codec=rc4 --without-rc4) 
}

multilib_src_compile() {
	default
	if multilib_is_native_abi && use doc; then
		docs_compile
	fi
}

multilib_src_install() {
	find "${D}" -name '*.la' -delete
	default
	if multilib_is_native_abi && use doc; then
		einstalldocs
	fi
}
