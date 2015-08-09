# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MY_P=${PN}-src-${PV}

inherit toolchain-funcs

DESCRIPTION="Simple, high-reliability, source control management, and more"
HOMEPAGE="http://www.fossil-scm.org/"
SRC_URI="http://www.fossil-scm.org/download/${MY_P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE="json +lineedit sqlite +ssl tcl"

DEPEND="
	sys-libs/zlib
	lineedit? ( || ( sys-libs/readline:0 dev-libs/libedit ) )
	ssl? ( dev-libs/openssl:0 )
	sqlite? ( dev-db/sqlite:3 )
	tcl? ( dev-lang/tcl:0= )
"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_P}

src_configure() {
	# this is not an autotools situation so don't make it seem like one
	# --with-tcl: works
	# --without-tcl: dies
	local myconf='--with-zlib'

	myconf+=" --lineedit=$(usex lineedit 1 0)"
	myconf+=" --with-openssl=$(usex ssl auto none)"
	use json   && myconf+=' --json'
	use sqlite && myconf+=' --disable-internal-sqlite'
	use tcl    && myconf+=' --with-tcl --with-tcl-stubs'
	tc-export CC
	./configure ${myconf} || die
}

src_install() {
	dobin fossil
}
