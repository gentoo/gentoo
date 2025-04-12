# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic multilib-minimal

DESCRIPTION="Full Database Encryption for SQLite"
HOMEPAGE="
	https://www.zetetic.net/sqlcipher/
	https://github.com/sqlcipher/sqlcipher
"
SRC_URI="https://github.com/sqlcipher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="debug libedit readline tcl test"
# Testsuite requires compilation with TCL, bug #582584
REQUIRED_USE="
	?? ( libedit readline )
	test? ( tcl )
"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-libs/openssl:=[${MULTILIB_USEDEP}]
	sys-libs/zlib[${MULTILIB_USEDEP}]
	libedit? ( dev-libs/libedit[${MULTILIB_USEDEP}] )
	readline? ( sys-libs/readline:=[${MULTILIB_USEDEP}] )
	tcl? ( dev-lang/tcl:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}"
BDEPEND="dev-lang/tcl"

src_configure() {
	# Column metadata added due to bug #670346
	append-cflags -DSQLITE_HAS_CODEC -DSQLITE_ENABLE_COLUMN_METADATA

	multilib-minimal_src_configure
}

multilib_src_configure() {
	local myeconfargs=(
		--enable-fts3
		--enable-fts4
		--enable-fts5
		--enable-geopoly
		--enable-memsys5
		--enable-rtree
		--enable-session
		--enable-tempstore
		$(use_enable debug)
		$(use_enable libedit editline)
		$(use_enable readline)
		$(use_enable tcl)
	)
	ECONF_SOURCE="${S}" \
		econf "${myeconfargs[@]}"
}

multilib_src_install_all() {
	einstalldocs
	find "${ED}" -name '*.la' -type f -delete || die
}
