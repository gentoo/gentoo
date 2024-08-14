# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PV_COMMIT=77bb2ba5eadfb95b67abccd22b298cfb75dd3328

PYTHON_COMPAT=( python3_{9..11} )

inherit cmake flag-o-matic python-single-r1

PATCHSET_VER="3"

DESCRIPTION="YAP is a high-performance Prolog compiler"
HOMEPAGE="https://web.archive.org/web/20181115131216/http://www.dcc.fc.up.pt/~vsc/Yap/"
SRC_URI="https://github.com/vscosta/yap/archive/${PV_COMMIT}.tar.gz -> ${PN}-${PV_COMMIT}.tar.gz
	https://dev.gentoo.org/~keri/distfiles/yap/${P}-gentoo-patchset-${PATCHSET_VER}.tar.gz"

LICENSE="Artistic LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="R debug doc examples java mpi mysql odbc postgres python raptor readline sqlite static threads xml"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/libutf8proc
	sys-libs/zlib
	dev-libs/gmp:0[cxx]
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
	doc? ( app-text/doxygen[dot] )
	java? ( dev-lang/swig )
	python? ( >=dev-lang/swig-4.0.0 )"

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_unpack() {
	default
	mv "${WORKDIR}"/yap-${PV_COMMIT} "${WORKDIR}"/${P} || die
}

src_prepare() {
	if [[ -d "${WORKDIR}"/${PV} ]] ; then
		eapply "${WORKDIR}"/${PV}
	fi

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
		-DWITH_Java=$(usex java)
		-DWITH_Python3=$(usex python)
		-DWITH_SWIG=$(if use java || use python; then echo yes; else echo no; fi)
		-DWITH_R=$(usex R)
		-DWITH_Raptor2=$(usex raptor)
		-DWITH_XML=$(usex xml)
		-DWITH_LibXml2=$(if use raptor && use xml; then echo yes; else echo no; fi)
		-DWITH_DOCS=$(usex doc)
		-DWITH_CUDD=no
		-DWITH_Gecode=no
	)

	use python && mycmakeargs+=( -DPython3_EXECUTABLE="${PYTHON}" )

	cmake_src_configure
}

src_compile() {
	cmake_src_compile

	if use doc; then
		cmake_src_compile docs
	fi
}

src_install() {
	cmake_src_install

	dodoc README
	if use doc; then
		dodoc -r "${BUILD_DIR}"/html
	fi
}
