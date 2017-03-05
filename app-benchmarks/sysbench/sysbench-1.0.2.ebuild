# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="System performance benchmark"
HOMEPAGE="https://github.com/akopytov/sysbench"
SRC_URI="https://github.com/akopytov/sysbench/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aio mysql postgres test"

RDEPEND="aio? ( dev-libs/libaio )
	mysql? ( virtual/libmysqlclient )
	postgres? ( dev-db/postgresql:= )"
DEPEND="${RDEPEND}
	app-editors/vim-core
	dev-lang/luajit:=
	dev-libs/concurrencykit
	dev-libs/libxslt
	sys-devel/libtool:=
	virtual/pkgconfig
	test? ( dev-util/cram )"

src_prepare() {
	default

	sed -i -e "/^htmldir =/s:=.*:=/usr/share/doc/${PF}/html:" doc/Makefile.am || die

	# remove bundled libs
	rm -r third_party/luajit/luajit third_party/concurrency_kit/ck || die

	./autogen.sh || die
}

src_configure() {
	local myeconfargs=(
		$(use_enable aio aio)
		$(use_with mysql mysql)
		$(use_with postgres pgsql)
		--without-attachsql
		--without-drizzle
		--without-oracle
		--with-system-luajit
		--with-system-ck
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	emake check test
}
