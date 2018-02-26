# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools pax-utils

DESCRIPTION="System performance benchmark"
HOMEPAGE="https://github.com/akopytov/sysbench"
SRC_URI="https://github.com/akopytov/sysbench/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="aio mysql postgres test"

RDEPEND="aio? ( dev-libs/libaio )
	mysql? ( virtual/libmysqlclient )
	postgres? ( dev-db/postgresql:= )
	dev-lang/luajit:="
DEPEND="${RDEPEND}
	dev-libs/concurrencykit
	dev-libs/libxslt
	sys-devel/libtool
	virtual/pkgconfig
	test? ( dev-util/cram )"

PATCHES=(
	"${FILESDIR}/${P}-htmldir-fix.patch"
)

src_prepare() {
	default

	# remove bundled libs
	rm -r third_party/luajit/luajit third_party/concurrency_kit/ck third_party/cram || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable aio)
		$(use_with mysql)
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

src_install() {
	default

	pax-mark m "${ED%/}"/usr/bin/${PN}
}
