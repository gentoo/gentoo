# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit db-use libtool

DESCRIPTION="High-level interface for the Resource Description Framework"
HOMEPAGE="http://librdf.org/"
SRC_URI="http://download.librdf.org/source/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="berkdb iodbc mysql odbc postgres sqlite"

RDEPEND="
	dev-libs/libltdl:0
	mysql? ( dev-db/mysql-connector-c:0= )
	sqlite? ( =dev-db/sqlite-3* )
	berkdb? ( sys-libs/db:* )
	>=media-libs/raptor-2.0.14
	>=dev-libs/rasqal-0.9.32
	postgres? ( dev-db/postgresql:* )
	iodbc? ( dev-db/libiodbc )
	odbc? ( dev-db/unixODBC )"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-mysql-8-my_bool.patch
	# bug 468298
	"${FILESDIR}"/${P}-ldflags-pc-leak.patch
)

src_prepare() {
	default
	elibtoolize # NOTE: this is for fbsd .so version
}

src_configure() {
	local myconf=( --without-virtuoso )
	if use iodbc; then
		myconf=( --with-virtuoso --with-iodbc --without-unixodbc )
	elif use odbc; then
		myconf=( --with-virtuoso --with-unixodbc --without-iodbc )
	fi

	if use berkdb; then
		myconf+=(
			--with-bdb-include="$(db_includedir)"
			--with-bdb-lib="${ESYSROOT}"/usr/$(get_libdir)
			--with-bdb-dbname="$(db_libname)"
		)
	fi

	# FIXME: upstream doesn't test with --with-threads and testsuite fails
	econf \
		$(use_with berkdb bdb) \
		$(use_with mysql) \
		$(use_with sqlite) \
		$(use_with postgres postgresql) \
		--without-threads \
		--with-html-dir="${EPREFIX}"/usr/share/gtk-doc/html/ \
		"${myconf[@]}"
}

src_test() {
	if ! use berkdb; then
		export REDLAND_TEST_CLONING_STORAGE_TYPE=hashes
		export REDLAND_TEST_CLONING_STORAGE_NAME=test
		export REDLAND_TEST_CLONING_STORAGE_OPTIONS="hash-type='memory',dir='.',write='yes',new='yes',contexts='yes'"
	fi

	default
}

src_install() {
	HTML_DOCS=( {FAQS,NEWS,README,RELEASE,TODO}.html )
	default

	find "${ED}" -name '*.la' -delete || die
}
