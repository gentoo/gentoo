# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/sqlcipher/sqlcipher-3.3.0.ebuild,v 1.1 2015/04/21 09:11:00 pinkbyte Exp $

EAPI=5

AUTOTOOLS_AUTORECONF=1
inherit autotools-multilib flag-o-matic

DESCRIPTION="Full Database Encryption for SQLite"
HOMEPAGE="http://sqlcipher.net/"
SRC_URI="https://github.com/sqlcipher/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="readline static-libs tcl"

# Tcl is always needed by buildsystem
RDEPEND="dev-libs/openssl:0[${MULTILIB_USEDEP}]
	readline? ( sys-libs/readline:0[${MULTILIB_USEDEP}] )
	tcl? ( dev-lang/tcl:=[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	dev-lang/tcl"

src_prepare() {
	append-cflags -DSQLITE_HAS_CODEC

	autotools-multilib_src_prepare
}

src_configure()
{
	local myeconfargs=(
		--enable-tempstore=yes
		$(use_enable readline)
		$(use_enable tcl)
	)
	autotools-multilib_src_configure
}
