# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit git-r3

DESCRIPTION="System performance benchmark"
HOMEPAGE="https://github.com/akopytov/sysbench"

EGIT_REPO_URI="https://github.com/akopytov/sysbench.git"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS=""
IUSE="aio mysql postgres test"

RDEPEND="aio? ( dev-libs/libaio )
	mysql? ( virtual/libmysqlclient )
	postgres? ( dev-db/postgresql:= )
	dev-lang/luajit:="
DEPEND="${RDEPEND}
	app-editors/vim-core
	dev-libs/concurrencykit
	dev-libs/libxslt
	sys-devel/libtool
	virtual/pkgconfig
	test? ( dev-util/cram )"

src_prepare() {
	default

	# remove bundled libs
	rm -r third_party/luajit/luajit third_party/concurrency_kit/ck third_party/cram || die

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
