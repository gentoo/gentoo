# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6..9} )

inherit autotools python-single-r1

DESCRIPTION="A scriptable multi-threaded benchmark tool based on LuaJIT"
HOMEPAGE="https://github.com/akopytov/sysbench"
SRC_URI="https://github.com/akopytov/sysbench/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
IUSE="+aio attachsql drizzle +largefile mysql postgres test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-lang/luajit:2
	aio? ( dev-libs/libaio )
	mysql? ( dev-db/mysql-connector-c:= )
	postgres? ( dev-db/postgresql:= )
	test? ( ${PYTHON_DEPS} )
"
DEPEND="
	dev-libs/concurrencykit
	dev-libs/libxslt
	test? (
		$(python_gen_cond_dep '
			dev-util/cram[${PYTHON_USEDEP}]
		')
	)
	${RDEPEND}
"
BDEPEND="
	sys-devel/libtool
	virtual/pkgconfig
"

src_prepare() {
	default

	rm -r third_party/{concurrency_kit/ck,cram,luajit/luajit} || die

	eautoreconf
}

src_configure() {
	# Current versions of 'dev-db/oracle-instantclient' aren't supported.
	# See: https://github.com/akopytov/sysbench/issues/390.
	local myeconfargs=(
		--disable-rpath
		$(use_enable aio)
		$(use_enable largefile)
		$(use_with attachsql)
		$(use_with drizzle)
		$(use_with mysql)
		$(use_with postgres pgsql)
		--with-system-ck
		--with-system-luajit
		--without-oracle
	)

	econf "${myeconfargs[@]}"
}

src_test() {
	emake check test
}
