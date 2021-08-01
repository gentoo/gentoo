# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

MY_PN="tidy-html5"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tidy the layout and correct errors in HTML and XML documents"
HOMEPAGE="https://www.html-tidy.org/"
SRC_URI="https://github.com/htacg/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"

# TODO: get this going - needs Ruby + a bunch of gems
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-5.8.0-no_static_lib.patch
)

DOCS=( README.md README/CHANGELOG.md )

S="${WORKDIR}"/${MY_P}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TAB2SPACE=ON	# for compatibility with W3C versions
		-DTIDY_COMPAT_HEADERS=ON # ditto
		-DTIDY_CONSOLE_SHARED=ON
	)
	cmake_src_configure
}

src_test() {
	pushd regression_testing >/dev/null || die
	# FIXME: use the correct Ruby interpreter
	./test.rb test || die "Test execution failed"
	popd >/dev/null || die
}
