# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )

inherit flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Convert files between various character sets"
HOMEPAGE="https://github.com/rrthomas/recode"
SRC_URI="https://github.com/rrthomas/recode/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
# librecode soname version
SLOT="0/3"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
IUSE="nls test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/libiconv"
DEPEND="
	${RDEPEND}
	sys-devel/flex
"
BDEPEND="
	nls? ( sys-devel/gettext )
	test? (
		${PYTHON_DEPS}
		$(python_gen_any_dep '
			dev-python/cython[${PYTHON_USEDEP}]
		')
	)
"

python_check_deps() {
	python_has_version "dev-python/cython[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_configure() {
	tc-export CC LD

	# on solaris -lintl is needed to compile
	[[ ${CHOST} == *-solaris* ]] && append-libs "-lintl"

	# --without-included-gettext means we always use system headers
	# and library
	econf \
		$(use_enable nls) \
		--disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
