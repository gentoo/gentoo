# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit toolchain-funcs

DESCRIPTION="A thread safe high level multi-database connection pool library"
HOMEPAGE="https://www.tildeslash.com/libzdb/"
SRC_URI="https://www.tildeslash.com/${PN}/dist/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc mysql postgres +sqlite ssl static-libs"
REQUIRED_USE=" || ( postgres mysql sqlite )"

RESTRICT=test

RDEPEND="mysql? ( dev-db/mysql-connector-c:0= )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( >=dev-db/sqlite-3.7:3[unlock-notify(+)] )
	ssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_prepare() {
	default
	sed -i -e "s|&& ./pool||g" test/Makefile.in || die
}

src_configure() {
	## TODO: check what --enable-optimized actually does
	## TODO: find someone with oracle db to add oci8 support
	myconf=""
	# enable default hidden visibility
	myconf="${myconf} --enable-protected"

	if use sqlite; then
		myconf="${myconf} --with-sqlite=${EPREFIX}/usr/ --enable-sqliteunlock"
	else
		myconf="${myconf} --without-sqlite"
	fi

	if use mysql; then
		myconf="${myconf} --with-mysql=${EPREFIX}/usr/bin/mysql_config"
	else
		myconf="${myconf} --without-mysql"
	fi

	if use postgres; then
		myconf="${myconf} --with-postgresql=${EPREFIX}/usr/bin/pg_config"
	else
		myconf="${myconf} --without-postgresql"
	fi

	econf \
		$(use_enable debug profiling) \
		$(use_enable static-libs static) \
		$(use_enable ssl openssl) \
		--without-oci \
		${myconf}
}

src_compile() {
	default
	if use doc; then
		emake doc
	fi
}

src_install() {
	default

	# the --disable-static flag only skips .a
	use static-libs || rm -f "${D}"/usr/lib*/libzdb.la

	dodoc AUTHORS CHANGES README
	if use doc;then
		docinto html
		dodoc -r "${S}/doc/api-docs"/*
	fi
}

src_test() {
	emake verify
}
