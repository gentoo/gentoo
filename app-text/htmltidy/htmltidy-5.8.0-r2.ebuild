# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby26 ruby27 ruby30 ruby31 ruby32"
RUBY_OPTIONAL="yes"

inherit cmake ruby-ng

MY_PN="tidy-html5"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tidy the layout and correct errors in HTML and XML documents"
HOMEPAGE="https://www.html-tidy.org/"
SRC_URI="https://github.com/htacg/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/58" # subslot is SOVERSION
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="deprecated test"

RESTRICT="!test? ( test )"
ruby_add_bdepend "test? ( dev-ruby/thor dev-ruby/tty-editor )"

PATCHES=(
	"${FILESDIR}"/${PN}-5.8.0-no_static_lib.patch
	"${FILESDIR}"/${PN}-5.8.0-ol_type.patch
)

DOCS=( README.md README/CHANGELOG.md )

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	use test && ruby-ng_pkg_setup
}

src_unpack() {
	# suppress ruby-ng export
	default
}

src_prepare() {
	# suppress ruby-ng export
	cmake_src_prepare
}

src_compile() {
	# suppress ruby-ng export
	cmake_src_compile
}

src_configure() {
	local mycmakeargs=(
		-DTIDY_CONSOLE_SHARED=ON
	)
	use deprecated && mycmakeargs+=(
		-DBUILD_TAB2SPACE=ON
		-DTIDY_COMPAT_HEADERS=ON
	)
	cmake_src_configure
}

src_test() {
	cd regression_testing || die
	rm -f Gemfile.lock
	${RUBY} ./test.rb test -t "${BUILD_DIR}/tidy" || die "Test execution failed"
}

src_install() {
	cmake_src_install
	use deprecated && dobin "${BUILD_DIR}"/tab2space
}
