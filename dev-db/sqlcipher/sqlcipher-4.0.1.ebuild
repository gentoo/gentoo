# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools flag-o-matic multilib-minimal

DESCRIPTION="Full Database Encryption for SQLite"
HOMEPAGE="https://www.zetetic.net/sqlcipher/"
SRC_URI="https://github.com/sqlcipher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="debug libedit readline libressl static-libs tcl test"

# Tcl is always needed by buildsystem
RDEPEND="
	libedit? ( dev-libs/libedit[${MULTILIB_USEDEP}] )
	!libressl? ( dev-libs/openssl:0=[${MULTILIB_USEDEP}] )
	libressl? ( dev-libs/libressl:0=[${MULTILIB_USEDEP}] )
	readline? ( sys-libs/readline:0=[${MULTILIB_USEDEP}] )
	tcl? ( dev-lang/tcl:=[${MULTILIB_USEDEP}] )
"
DEPEND="${RDEPEND}
	dev-lang/tcl:*"

# Libedit and readline support are mutually exclusive
# Testsuite requires compilation with TCL, bug #582584
REQUIRED_USE="
	libedit? ( !readline )
	test? ( tcl )
"

DOCS=( README.md )

# Testsuite fails, bug #692310
RESTRICT="test"

src_prepare() {
	# Column metadata added due to bug #670346
	append-cflags -DSQLITE_HAS_CODEC -DSQLITE_ENABLE_COLUMN_METADATA

	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		--enable-fts3 \
		--enable-fts4 \
		--enable-fts5 \
		--enable-geopoly \
		--enable-json1 \
		--enable-memsys5 \
		--enable-rtree \
		--enable-session \
		--enable-tempstore \
		$(use_enable debug) \
		$(use_enable libedit editline) \
		$(use_enable readline) \
		$(use_enable static-libs static) \
		$(use_enable tcl)
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -type f -delete || die
	einstalldocs
}
