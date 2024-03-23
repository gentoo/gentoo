# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_MAKE_BASE=$(ver_cut 1-2)
MY_REMAKE_PATCH=$(ver_cut 4-)
MY_P="${PN}-${MY_MAKE_BASE}+dbg-${MY_REMAKE_PATCH}"

inherit flag-o-matic

DESCRIPTION="Patched version of GNU Make with improved error reporting, tracing and debugging"
HOMEPAGE="http://bashdb.sourceforge.net/remake/"
SRC_URI="https://github.com/rocky/remake/releases/download/${MY_P}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="guile readline"

DEPEND="readline? ( sys-libs/readline:0= )"
RDEPEND="
	${DEPEND}
	guile? ( >=dev-scheme/guile-1.8:= )
"
BDEPEND="guile? ( >=dev-scheme/guile-1.8 )"

src_configure() {
	# Fixed in upstream make/gnulib, just not yet propagated into remake (bug #863827)
	filter-lto

	use readline || export vl_cv_lib_readline=no
	econf $(use_with guile)
}

src_install() {
	default

	# delete files GNU make owns and remake doesn't care about.
	rm -r "${ED}"/usr/include || die
	rm "${ED}"/usr/share/info/make.info* || die
}
