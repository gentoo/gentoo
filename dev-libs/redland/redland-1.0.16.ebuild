# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=4
inherit db-use libtool

DESCRIPTION="High-level interface for the Resource Description Framework"
HOMEPAGE="http://librdf.org/"
SRC_URI="http://download.librdf.org/source/${P}.tar.gz"

LICENSE="Apache-2.0 GPL-2 LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm ~hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="berkdb iodbc mysql odbc postgres sqlite static-libs +xml"

RDEPEND="dev-libs/libltdl:0
	mysql? ( virtual/mysql )
	sqlite? ( =dev-db/sqlite-3* )
	berkdb? ( sys-libs/db )
	xml? ( dev-libs/libxml2 )
	!xml? ( >=dev-libs/expat-2 )
	>=media-libs/raptor-2.0.7
	>=dev-libs/rasqal-0.9.28
	postgres? ( dev-db/postgresql )
	iodbc? ( dev-db/libiodbc )
	odbc? ( dev-db/unixODBC )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	elibtoolize # NOTE: this is for fbsd .so version
}

src_configure() {
	local parser=expat
	use xml && parser=libxml

	local myconf=( --without-virtuoso )
	if use iodbc; then
		myconf=( --with-virtuoso --with-iodbc --without-unixodbc )
	elif use odbc; then
		myconf=( --with-virtuoso --with-unixodbc --without-iodbc )
	fi

	if use berkdb; then
		myconf+=(
			--with-bdb-include="$(db_includedir)"
			--with-bdb-lib="${EPREFIX}"/usr/$(get_libdir)
			--with-bdb-dbname="$(db_libname)"
		)
	fi

	# FIXME: upstream doesn't test with --with-threads and testsuite fails
	econf \
		$(use_enable static-libs static) \
		$(use_with berkdb bdb) \
		--with-xml-parser=${parser} \
		$(use_with mysql) \
		$(use_with sqlite) \
		$(use_with postgres postgresql) \
		--without-threads \
		--with-html-dir="${EPREFIX}"/usr/share/doc/${PF}/html \
		"${myconf[@]}"
}

src_compile() {
	emake -j1
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
	default
	dohtml {FAQS,NEWS,README,RELEASE,TODO}.html
	find "${ED}" -name '*.la' -exec sed -i -e "/^dependency_libs/s:=.*:='':" {} +

	# !!! REMOVE THIS ON VERSION BUMP, see bug 468298 for proper fix !!!
	if [[ -n ${LDFLAGS} ]] ; then
		sed -i \
			-e "s:${LDFLAGS} ::g" \
			"${ED}"/usr/$(get_libdir)/pkgconfig/redland.pc || die
	fi
}
