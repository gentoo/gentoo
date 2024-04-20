# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..11} )

inherit autotools flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Convert files between various character sets"
HOMEPAGE="https://github.com/rrthomas/recode"
SRC_URI="https://github.com/rrthomas/recode/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-3+"
# librecode soname version
SLOT="0/3"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos"
IUSE="nls test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/libiconv"
DEPEND="
	${RDEPEND}
	app-alternatives/lex
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

PATCHES=(
	"${FILESDIR}"/${P}-no-help2man.patch
)

python_check_deps() {
	python_has_version "dev-python/cython[${PYTHON_USEDEP}]"
}

pkg_setup() {
	use test && python-any-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	tc-export CC LD

	# on solaris -lintl is needed to compile
	[[ ${CHOST} == *-solaris* ]] && append-libs "-lintl"

	# -fanalyzer substantially slows down the build and isn't useful for
	# us. It's useful for upstream as it's static analysis, but it's not
	# useful when just getting something built.
	export gl_cv_warn_c__fanalyzer=no

	econf \
		$(use_enable nls) \
		--disable-static
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete || die
}
