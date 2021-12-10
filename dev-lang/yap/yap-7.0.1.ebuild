# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit cmake flag-o-matic python-single-r1

DESCRIPTION="YAP is a high-performance Prolog compiler"
HOMEPAGE="http://www.dcc.fc.up.pt/~vsc/Yap/"
SRC_URI="https://dev.gentoo.org/~keri/distfiles/yap/${P}.tar.gz"

LICENSE="Artistic LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="R debug doc examples java mpi mysql odbc postgres python raptor readline sqlite static threads xml"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/libutf8proc
	sys-libs/zlib
	dev-libs/gmp:0
	java? ( >=virtual/jdk-1.8:* )
	mpi? ( virtual/mpi )
	mysql? ( dev-db/mysql-connector-c:0= )
	odbc? ( dev-db/unixODBC )
	postgres? ( dev-db/postgresql:= )
	R? ( dev-lang/R )
	python? (
		${PYTHON_DEPS}
		dev-python/wheel
		dev-python/numpy
	)
	raptor? ( media-libs/raptor )
	readline? ( sys-libs/readline:= sys-libs/ncurses:= )
	sqlite? ( dev-db/sqlite )
	xml? ( dev-libs/libxml2 )"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
	java? ( dev-lang/swig )
	python? ( dev-lang/swig )"

src_prepare() {
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		eapply "${WORKDIR}"/${PV}
	fi

	sed -i \
		-e "s|\(set ( libdir \"\${exec_prefix}\)/lib\")|\1/$(get_libdir)\")|" \
		-e "s|\(set ( dlls \"\${exec_prefix}\)/lib/Yap\")|\1/$(get_libdir)/Yap\")|" \
		-e "s|\(set ( docdir \"\${exec_prefix}/share/doc\)/Yap\")|\1/${PF}\")|" \
		CMakeLists.txt || die

	cmake_src_prepare
}

src_configure() {

	local mycmakeargs=(
		-DWITH_YAP_STATIC=$(usex static)
		-DWITH_THREADED_CODE=$(usex threads)
		-DWITH_READLINE=$(usex readline)
		-DWITH_MPI=$(usex mpi)
		-DWITH_ODBC=$(usex odbc)
		-DWITH_MYSQL=$(usex mysql)
		-DWITH_POSTGRES=$(usex postgres)
		-DWITH_SQLITE3=$(usex sqlite)
		-DWITH_JAVA=$(usex java)
		-DWITH_PYTHON=$(usex python)
		-DWITH_SWIG=$(if use java || use python; then echo yes; else echo no; fi)
		-DWITH_R=$(usex R)
		-DWITH_Raptor2=$(usex raptor)
		-DWITH_XML=$(usex xml)
		-DWITH_XML2=$(if use raptor && use xml; then echo yes; else echo no; fi)
		-DWITH_DOCS=$(usex doc)
		-DWITH_CUDD=no
		-DWITH_GECODE=no
	)

	use python && mycmakeargs+=( -DPython3_EXECUTABLE="${PYTHON}" )

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_src_compile doxygen
	fi
}

src_install() {
	cmake_src_install

	dodoc README
	if use doc; then
		dodoc -r "${BUILD_DIR}"/html
	fi
}
