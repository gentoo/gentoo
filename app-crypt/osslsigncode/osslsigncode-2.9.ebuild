# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..13} )

inherit bash-completion-r1 cmake python-any-r1

DESCRIPTION="Platform-independent tool for Authenticode signing of EXE/CAB files"
HOMEPAGE="https://github.com/mtrojnar/osslsigncode"
SRC_URI="
	https://github.com/mtrojnar/${PN}/archive/refs/tags/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	sys-libs/zlib:=
	>=dev-libs/openssl-3:=
"
DEPEND="${RDEPEND}"
BDEPEND="
	test? (
		$(python_gen_any_dep '
			dev-python/cryptography[${PYTHON_USEDEP}]
		')
	)
"

PATCHES=(
	"${FILESDIR}/${P}-missing-import.patch"
)

python_check_deps() {
	use test || return 0
	python_has_version "dev-python/cryptography[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_test() {
	cmake_src_test -j1
}

src_install() {
	cmake_src_install

	mv "${D}$(get_bashcompdir)/${PN}"{.bash,} || die #927196
}
