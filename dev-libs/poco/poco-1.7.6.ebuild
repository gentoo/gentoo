# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils

DESCRIPTION="C++ class libraries for building network- and internet-based applications"
HOMEPAGE="http://pocoproject.org/"
SRC_URI="https://github.com/pocoproject/${PN}/archive/${P}-release.tar.gz -> ${P}.tar.gz"
LICENSE="Boost-1.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="7z apache cppparser +crypto +data examples +file2pagecompiler +json +pagecompiler iodbc libressl +mongodb mysql +net odbc pdf pocodoc sqlite +ssl test +util +xml +zip"
REQUIRED_USE="7z? ( xml )
	apache? ( net util )
	file2pagecompiler? ( pagecompiler )
	iodbc? ( odbc )
	mongodb? ( data )
	mysql? ( data )
	odbc? ( data )
	pagecompiler? ( json net util xml )
	pocodoc? ( cppparser util xml )
	sqlite? ( data )
	test? ( data? ( sqlite ) json util xml )"

RDEPEND=">=dev-libs/libpcre-8.13
	xml? ( dev-libs/expat )
	apache? ( dev-libs/apr
		dev-libs/apr-util
		www-servers/apache )
	mysql? ( virtual/mysql )
	odbc? ( iodbc? ( dev-db/libiodbc )
		!iodbc? ( dev-db/unixODBC ) )
	ssl? (
		!libressl? ( <dev-libs/openssl-1.1.0:0 )
		libressl? ( dev-libs/libressl )
	)
	sqlite? ( dev-db/sqlite:3 )
	zip? ( sys-libs/zlib )"
DEPEND="${DEPEND}
	virtual/pkgconfig"

S="${WORKDIR}/${PN}-${P}-release"

PATCHES=( "${FILESDIR}/${PN}-1.7.2-iodbc-incdir.patch" )

src_prepare() {
	if use test ; then
		# ignore missing tests on experimental library
		# and tests requiring running DB-servers, internet connections, etc.
		sed -i \
			-e '/testsuite/d' \
			{Data/{MySQL,ODBC},MongoDB,Net,NetSSL_OpenSSL,PDF}/CMakeLists.txt || die
		# Poco expands ~ using passwd, which does not match $HOME in the build environment
		sed -i \
			-e '/CppUnit_addTest.*testExpand/d' \
			Foundation/testsuite/src/PathTest.cpp || die
		# ignore failing Crypto test since upstream does not seem to care,
		# see https://github.com/pocoproject/poco/issues/1209
		sed -i \
			-e '/RSATest, testRSACipherLarge/d' \
			Crypto/testsuite/src/RSATest.cpp || die
	fi

	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DPOCO_UNBUNDLED=ON
		-DENABLE_APACHECONNECTOR="$(usex apache)"
		-DENABLE_CPPPARSER="$(usex cppparser)"
		-DENABLE_CRYPTO="$(usex ssl)"
		-DENABLE_DATA="$(usex data)"
		-DENABLE_DATA_MYSQL="$(usex mysql)"
		-DENABLE_DATA_ODBC="$(usex odbc)"
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
		-DENABLE_SEVENZIP="$(usex 7z)"
		-DENABLE_TESTS="$(usex test)"
		-DENABLE_UTIL="$(usex util)"
		-DENABLE_XML="$(usex xml)"
		-DENABLE_ZIP="$(usex zip)"
	)

	if ! use iodbc ; then
		sed -i -e 's|iodbc||' cmake/FindODBC.cmake || die
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use examples ; then
		for sd in */samples ; do
			insinto /usr/share/doc/${PF}/examples/${sd%/samples}
			doins -r ${sd}
		done
		find "${D}/usr/share/doc/${PF}/examples" \
			-iname "*.sln" -or -iname "*.vcproj" -or \
			-iname "*.vmsbuild" -or -iname "*.properties" \
			| xargs rm
	fi
}
