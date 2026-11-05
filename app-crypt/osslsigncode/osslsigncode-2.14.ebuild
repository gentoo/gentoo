# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )

inherit cmake python-any-r1 shell-completion

DESCRIPTION="Platform-independent tool for Authenticode signing of EXE/CAB files"
HOMEPAGE="https://github.com/mtrojnar/osslsigncode"
SRC_URI="
	https://github.com/mtrojnar/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/zlib:=
	>=dev-libs/openssl-3:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	doc? ( virtual/pandoc )
	test? (
		$(python_gen_any_dep '
			dev-python/cryptography[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/cryptography[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	cmake_src_prepare
	if ! use doc; then
		sed -e '/^include(CMakeDoc)/d' -i CMakeLists.txt || die
	fi
}

src_test() {
	cmake_src_test -j1
}

src_install() {
	if use doc; then
		doman "${BUILD_DIR}"/osslsigncode.1
		local HTML_DOCS=( "${BUILD_DIR}"/osslsigncode.html )
	else
		newman "${FILESDIR}"/osslsigncode-2.14.1 osslsigncode.1
	fi

	cmake_src_install

	mv "${D}$(get_bashcompdir)/${PN}"{.bash,} || die #927196
}
