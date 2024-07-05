# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )
#OSSLSIGNCODE_TEST_FILES=( unsigned.{cat,ex_,exe,msi} )
inherit cmake python-any-r1

DESCRIPTION="Platform-independent tool for Authenticode signing of EXE/CAB files"
HOMEPAGE="https://github.com/mtrojnar/osslsigncode"
SRC_URI="https://github.com/mtrojnar/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

for test_file in "${OSSLSIGNCODE_TEST_FILES[@]}" ; do
	SRC_URI+=" test? ( https://github.com/mtrojnar/osslsigncode/raw/${PV}/tests/files/${test_file} -> ${PN}-test-${test_file} )"
done
unset test_file

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl test"
#RESTRICT="!test? ( test )"
# https://github.com/mtrojnar/osslsigncode/issues/140#issuecomment-1060636197
RESTRICT="test"

RDEPEND="
	dev-libs/openssl:=
	sys-libs/zlib:=
	curl? ( net-misc/curl )
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		${PYTHON_DEPS}
		sys-libs/libfaketime
	)
"

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	if use test ; then
		local test_file
		for test_file in "${OSSLSIGNCODE_TEST_FILES[@]}" ; do
			cp "${DISTDIR}"/${PN}-test-${test_file} tests/files/${test_file} || die
		done
		unset test_file
	fi

	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package curl CURL)
	)

	cmake_src_configure
}

src_test() {
	cmake_src_test -j1
}
