# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=YAP-${PV}

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake flag-o-matic python-r1

PATCHSET_VER="0"

DESCRIPTION="YAP is a high-performance Prolog compiler"
HOMEPAGE="http://www.dcc.fc.up.pt/~vsc/Yap/"
SRC_URI="https://github.com/vscosta/yap-6.3/archive/YAP-${PV}.tar.gz
	https://dev.gentoo.org/~keri/distfiles/yap/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="Artistic LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="R debug doc examples gmp java mpi mysql odbc postgres python raptor readline sqlite ssl static threads xml"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/libutf8proc
	sys-libs/zlib
	gmp? ( dev-libs/gmp:0 )
	java? ( >=virtual/jdk-1.8:* )
	mpi? ( virtual/mpi )
	mysql? ( dev-db/mysql-connector-c:0= )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql:= )
	R? ( dev-lang/R )
	python? ( ${PYTHON_DEPS} )
	raptor? ( media-libs/raptor )
	readline? ( sys-libs/readline:= sys-libs/ncurses:= )
	sqlite? ( dev-db/sqlite )
	ssl? ( dev-libs/openssl )
	xml? ( dev-libs/libxml2 )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
	java? ( dev-lang/swig )
	python? ( dev-lang/swig )"

S="${WORKDIR}"/yap-6.3-${MY_P}

src_prepare() {
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		eapply "${WORKDIR}"/${PV}
	fi

	sed -i \
		-e "s|\(set ( libdir \"\${exec_prefix}\)/lib\")|\1/$(get_libdir)\")|" \
		-e "s|\(set ( dlls \"\${exec_prefix}\)/lib/Yap\")|\1/$(get_libdir)/Yap\")|" \
		-e "s|\(set ( docdir \"\${exec_prefix}/share/doc\)/Yap\")|\1/${PF}\")|" \
		CMakeLists.txt || die
	rm -rf "${S}"/yap || die "failed to remove yap xcode project"

	cmake_src_prepare
}

src_configure() {
	append-flags -fno-strict-aliasing -fcommon -fno-inline-small-functions

	local mycmakeargs=(
		-DWITH_YAP_STATIC=$(usex static)
		-DWITH_Threads=$(usex threads)
		-DWITH_GMP=$(usex gmp)
		-DWITH_Readline=$(usex readline)
		-DCMAKE_DISABLE_FIND_PACKAGE_OpenSSL=$(usex !ssl)
		-DWITH_MPI=$(usex mpi)
		-DWITH_ODBC=$(usex odbc)
		-DWITH_MySQL=$(usex mysql)
		-DWITH_PostgreSQL=$(usex postgres)
		-DWITH_Sqlite3=$(usex sqlite)
		-DWITH_JNI=$(usex java)
		-DCMAKE_DISABLE_FIND_PACKAGE_Java=$(usex !java)
		-DWITH_PythonInterp=$(usex python)
		-DWITH_PythonLibs=$(usex python)
		-DWITH_SWIG=$(if use java || use python; then echo yes; else echo no; fi)
		-DWITH_R=$(usex R)
		-DWITH_RAPTOR=$(usex raptor)
		-DWITH_LibXml2=$(usex xml)
		-DWITH_DOCUMENTATION=$(usex doc)
		-DWITH_CUDD=no
		-DWITH_Gecode=no
		-DWITH_Matlab=no
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc ; then
		cmake_src_compile doc
	fi
}

src_test() {
	# libtai package contains check.c which confuses the default
	# src_test() function
	true
}

src_install() {
	cmake_src_install

	dodoc changes*.html README

	if use examples ; then
		docinto /usr/share/doc/${PF}/examples/chr
		dodoc packages/chr/Examples/*
		if use java ; then
			docinto /usr/share/doc/${PF}/examples/jpl/prolog
			dodoc packages/jpl/jpl/examples/prolog/*
			docinto /usr/share/doc/${PF}/examples/jpl/java
			dodoc packages/jpl/jpl/examples/java/README
			dodoc -r packages/jpl/jpl/examples/java/*/*.{java,pl}
		fi
		if use mpi ; then
			docinto /usr/share/doc/${PF}/examples/mpi
			dodoc library/mpi/examples/*.pl
		fi
	fi
}
