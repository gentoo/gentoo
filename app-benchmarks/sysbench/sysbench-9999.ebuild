# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit git-r3

DESCRIPTION="System performance benchmark"
HOMEPAGE="https://github.com/akopytov/sysbench"

EGIT_REPO_URI="https://github.com/akopytov/sysbench.git"
EGIT_BRANCH="1.0"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="aio mysql"

DEPEND="aio? ( dev-libs/libaio )
	mysql? ( virtual/libmysqlclient )"
RDEPEND="${DEPEND}"

src_prepare() {
	default

	sed -i -e "/^htmldir =/s:=.*:=/usr/share/doc/${PF}/html:" doc/Makefile.am || die

	./autogen.sh || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable aio aio)
		$(use_with mysql mysql)
	)

	econf "${myeconfargs[@]}"
}

src_install() {
	default

	insinto /usr/share/${PN}/tests/db
	doins sysbench/tests/db/*.lua || die
}
