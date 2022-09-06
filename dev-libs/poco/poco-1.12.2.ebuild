# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ libraries for building network-based applications"
HOMEPAGE="https://pocoproject.org/"
SRC_URI="https://github.com/pocoproject/${PN}/archive/${P}-release.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}-release"

LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 x86"
IUSE="7z activerecord cppparser +crypto +data examples +file2pagecompiler iodbc +json mariadb +mongodb mysql +net odbc +pagecompiler pdf pocodoc postgres prometheus sqlite +ssl test +util +xml +zip"
RESTRICT="!test? ( test )"
REQUIRED_USE="
	7z? ( xml )
	file2pagecompiler? ( pagecompiler )
	iodbc? ( odbc )
	mongodb? ( data )
	mysql? ( data )
	odbc? ( data )
	postgres? ( data )
	pagecompiler? ( json net util xml )
	pocodoc? ( cppparser util xml )
	sqlite? ( data )
	ssl? ( util )
	test? ( data? ( sqlite ) json util xml )
"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=dev-libs/libpcre-8.42
	activerecord? ( !app-arch/arc )
	mysql? ( dev-db/mysql-connector-c:0= )
	mariadb? ( dev-db/mariadb-connector-c:0= )
	postgres? ( dev-db/postgresql:= )
	odbc? (
		iodbc? ( dev-db/libiodbc )
		!iodbc? ( dev-db/unixODBC )
	)
	sqlite? ( dev-db/sqlite:3 )
	ssl? (
		dev-libs/openssl:0=
	)
	xml? ( dev-libs/expat )
	zip? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.10.1-iodbc-incdir.patch" )

src_prepare() {
	cmake_src_prepare

	if use test ; then
		# ignore missing tests on experimental library
		# and tests requiring running DB-servers, internet connections, etc.
		sed -i -e '/testsuite/d' \
			{Data/{MySQL,ODBC},MongoDB,Net,NetSSL_OpenSSL,PDF,Redis}/CMakeLists.txt || die
		# Poco expands ~ using passwd, which does not match $HOME in the build environment
		sed -i -e '/CppUnit_addTest.*testExpand/d' \
			Foundation/testsuite/src/PathTest.cpp || die
		# ignore failing Crypto test since upstream does not seem to care,
		# see https://github.com/pocoproject/poco/issues/1209
		sed -i -e '/RSATest, testRSACipherLarge/d' \
			Crypto/testsuite/src/RSATest.cpp || die
	fi

	# Fix MariaDB and MySQL detection
	sed -i -e 's~/usr/include/mysql~~' \
		-e 's/mysqlclient_r/mysqlclient/' \
		-e 's/STATUS "Couldn/FATAL_ERROR "Couldn/' \
		cmake/FindMySQL.cmake || die

	# Add missing directory that breaks the build
	mkdir -p Encodings/testsuite/data || die

	if ! use iodbc ; then
		sed -i -e 's|iodbc||' cmake/FindODBC.cmake || die
	fi
}

src_configure() {
	# apache support is dead and buggy, https://github.com/pocoproject/poco/issues/1764
	local mycmakeargs=(
		-DPOCO_UNBUNDLED=ON
		-DENABLE_APACHECONNECTOR=OFF
		-DENABLE_ACTIVERECORD="$(usex activerecord)"
		-DENABLE_ACTIVERECORD_COMPILER="$(usex activerecord)"
		-DENABLE_CPPPARSER="$(usex cppparser)"
		-DENABLE_CRYPTO="$(usex ssl)"
		-DENABLE_DATA="$(usex data)"
		-DENABLE_DATA_MYSQL="$(usex mysql)"
		-DENABLE_DATA_ODBC="$(usex odbc)"
		-DENABLE_DATA_POSTGRESQL="$(usex postgres)"
		-DENABLE_DATA_SQLITE="$(usex sqlite)"
		-DENABLE_JSON="$(usex util)"
		-DENABLE_MONGODB="$(usex mongodb)"
		-DENABLE_NET="$(usex net)"
		-DENABLE_NETSSL="$(usex ssl)"
		-DENABLE_NETSSL_WIN=OFF
		-DENABLE_PAGECOMPILER="$(usex pagecompiler)"
		-DENABLE_PAGECOMPILER_FILE2PAGE="$(usex file2pagecompiler)"
		-DENABLE_PDF="$(usex pdf)"
		-DENABLE_POCODOC="$(usex pocodoc)"
		-DENABLE_PROMETHEUS="$(usex prometheus)"
		-DENABLE_SEVENZIP="$(usex 7z)"
		-DENABLE_TESTS="$(usex test)"
		-DENABLE_UTIL="$(usex util)"
		-DENABLE_XML="$(usex xml)"
		-DENABLE_ZIP="$(usex zip)"
	)

	cmake_src_configure
}

src_test() {
	POCO_BASE="${S}" cmake_src_test -E DataPostgreSQL
}

src_install() {
	cmake_src_install

	if use examples ; then
		for sd in */samples ; do
			docinto examples/${sd%/samples}
			dodoc -r ${sd}
		done

		find "${D}/usr/share/doc/${PF}/examples" \
			-iname "*.sln" -or -iname "*.vcproj" -or \
			-iname "*.vmsbuild" -or -iname "*.properties" \
			| xargs rm -v || die
	fi
}
