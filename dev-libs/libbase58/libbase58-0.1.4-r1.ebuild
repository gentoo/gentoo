# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools multilib-minimal

DESCRIPTION="C implementation of Bitcoin's base58 encoding"
HOMEPAGE="https://github.com/luke-jr/libbase58"
LICENSE="MIT"

SRC_URI="https://github.com/luke-jr/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
SLOT="0/0"
KEYWORDS="~amd64 ~arm ~mips ~ppc ~ppc64 ~x86"
IUSE="test tools"
RESTRICT="!test? ( test )"

# NOTE: If not testing, we don't need non-native libgcrypt
RDEPEND="tools? ( dev-libs/libgcrypt )"
DEPEND="${RDEPEND}
	test? (
		app-editors/vim-core
		dev-libs/libgcrypt[${MULTILIB_USEDEP}]
	)
"

src_prepare() {
	eapply_user
	eautoreconf

	# NOTE: Needed because test suite uses srcdir instead of builddir to set PATH and for
	# multilib support.
	multilib_copy_sources
}

multilib_src_configure() {
	local myeconf=(
		--disable-static
		LIBGCRYPT_CONFIG="${EPREFIX}/usr/bin/${CHOST}-libgcrypt-config"
	)
	if multilib_is_native_abi && use tools; then
		myeconf+=( --enable-tool )
	elif use test; then
		myeconf+=( --enable-tool --bindir='/TRASH' )
	else
		myeconf+=( --disable-tool )
	fi
	econf "${myeconf[@]}"
}

multilib_src_install_all() {
	if use test; then
		# It's hard to control this directory with multilib_is_native_abi && use tools, hence -f.
		rm -rf "${ED}/TRASH" || die
	fi
}
