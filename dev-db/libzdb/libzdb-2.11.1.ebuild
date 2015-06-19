# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-db/libzdb/libzdb-2.11.1.ebuild,v 1.8 2014/12/28 15:04:44 titanofold Exp $

EAPI="4"

inherit eutils toolchain-funcs

DESCRIPTION="A thread safe high level multi-database connection pool library"
HOMEPAGE="http://www.tildeslash.com/libzdb/"
SRC_URI="http://www.tildeslash.com/${PN}/dist/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug doc mysql postgres +sqlite ssl static-libs"
REQUIRED_USE=" || ( postgres mysql sqlite )"

RESTRICT=test

RDEPEND="mysql? ( virtual/mysql )
	postgres? ( dev-db/postgresql )
	sqlite? ( >=dev-db/sqlite-3.7:3[unlock-notify(+)] )
	ssl? ( dev-libs/openssl )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( app-doc/doxygen )"

src_prepare() {
	sed -i -e "s|&& ./pool||g" test/Makefile.in || die
}

src_configure() {
	## TODO: check what --enable-optimized actually does
	## TODO: find someone with oracle db to add oci8 support
	myconf=""
	if  [[ $(gcc-version) < 4.1 ]];then
		myconf="${myconf} --disable-protected"
	else
		myconf="${myconf} --enable-protected"
	fi

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
	default_src_compile
	if use doc; then
		emake doc
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	# the --disable-static flag only skips .a
	use static-libs || rm -f "${D}"/usr/lib*/libzdb.la

	dodoc AUTHORS CHANGES README
	if use doc;then
		dohtml -r "${S}/doc/api-docs"/*
	fi
}

src_test() {
	emake verify
}
