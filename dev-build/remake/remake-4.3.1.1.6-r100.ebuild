# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

GUILE_COMPAT=( 2-2 3-0 )

inherit guile-single flag-o-matic

MY_MAKE_BASE=$(ver_cut 1-2)
MY_REMAKE_PATCH=$(ver_cut 4-)
MY_P="${PN}-${MY_MAKE_BASE}+dbg-${MY_REMAKE_PATCH}"

DESCRIPTION="Patched version of GNU Make with improved error reporting, tracing and debugging"
HOMEPAGE="http://bashdb.sourceforge.net/remake/"
SRC_URI="https://github.com/rocky/remake/releases/download/${MY_P}/${MY_P}.tar.gz"
S="${WORKDIR}"/${MY_P}

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="guile readline"

REQUIRED_USE="guile? ( ${GUILE_REQUIRED_USE} )"

RDEPEND="
	guile? ( ${GUILE_DEPS} )
	readline? ( sys-libs/readline:0= )
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-configure.patch )

pkg_setup() {
	use guile && guile-single_pkg_setup
}

src_prepare() {
	default

	use guile && guile_bump_sources
}

src_configure() {
	# Fixed in upstream make/gnulib, just not yet propagated into remake (bug #863827)
	filter-lto

	use readline || export vl_cv_lib_readline=no
	econf $(use_with guile)
}

src_install() {
	default

	use guile && guile_unstrip_ccache

	# delete files GNU make owns and remake doesn't care about.
	rm -r "${ED}"/usr/include || die
	rm "${ED}"/usr/share/info/make.info* || die
}
