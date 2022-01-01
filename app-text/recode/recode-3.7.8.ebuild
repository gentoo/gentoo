# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit flag-o-matic python-any-r1 toolchain-funcs

DESCRIPTION="Convert files between various character sets"
HOMEPAGE="https://github.com/rrthomas/recode"
SRC_URI="https://github.com/rrthomas/recode/releases/download/v${PV}/${P}.tar.gz"

LICENSE="GPL-2"
# librecode soname version
SLOT="0/3"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"
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
	if use test ; then
		has_version -b "dev-python/cython[${PYTHON_USEDEP}]" || return 1
	fi
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
