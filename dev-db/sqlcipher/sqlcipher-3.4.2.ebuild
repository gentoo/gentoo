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

IUSE="libedit readline libressl static-libs tcl test"
RESTRICT="!test? ( test )"

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

src_prepare() {
	# bug #678502
	eapply "${FILESDIR}/${P}-libressl-2.8.patch"

	append-cflags -DSQLITE_HAS_CODEC
	default
	eautoreconf
}

multilib_src_configure() {
	ECONF_SOURCE="${S}" \
	econf \
		--enable-fts3 \
		--enable-fts4 \
		--enable-fts5 \
		--enable-json1 \
		--enable-tempstore \
		$(use_enable libedit editline) \
		$(use_enable readline) \
		$(use_enable static-libs static) \
		$(use_enable tcl)
}

multilib_src_install_all() {
	find "${ED}" -name '*.la' -delete || die

	einstalldocs
}
