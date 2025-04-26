# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-${PV:0:3}-${PV:4}"

GUILE_COMPAT=( 2-2 3-0 )

inherit guile-single flag-o-matic

DESCRIPTION="Patched version of GNU Make with improved error reporting, tracing and debugging"
HOMEPAGE="https://bashdb.sourceforge.net/remake/"

if [[ ${PV} == *_pre* ]] ; then
	inherit autotools

	# remake for newer remake versions doesn't (yet?) have tags, so we
	# take snapshots. Make sure to pick the right branch.
	REMAKE_COMMIT="4ad367fd62caec8fcaa4dc1cc481a1e4d8bf6a7d"
	SRC_URI="
		https://github.com/Trepan-Debuggers/remake/archive/${REMAKE_COMMIT}.tar.gz -> ${P}.gh.tar.gz
	"
	S="${WORKDIR}"/${PN}-${REMAKE_COMMIT}
else
	SRC_URI="https://github.com/rocky/remake/releases/download/${MY_P}/${MY_P}.tar.gz"
	S="${WORKDIR}"/${MY_P}
fi

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
IUSE="guile readline"
REQUIRED_USE="guile? ( ${GUILE_REQUIRED_USE} )"

# Tests fail with a link error
RESTRICT="test"

RDEPEND="
	guile? ( ${GUILE_DEPS} )
	readline? ( sys-libs/readline:= )
"
DEPEND="${RDEPEND}"

pkg_setup() {
	use guile && guile-single_pkg_setup
}

src_prepare() {
	default

	[[ ${PV} == *_pre* ]] && eautoreconf

	use guile && guile_bump_sources
}

src_configure() {
	# Fixed in upstream gnulib but not yet propagated into make (bug #938934)
	append-cflags -std=gnu17
	# Fixed in upstream make/gnulib, just not yet propagated into remake (bug #863827)
	filter-lto

	use readline || export vl_cv_lib_readline=no
	econf \
		$(use_with guile) \
		--disable-nls \
		MAKEINFO=:
}

src_install() {
	default

	use guile && guile_unstrip_ccache

	# delete files GNU make owns and remake doesn't care about.
	# (commented out in *_pre, but may be needed on proper releases)
	#rm -r "${ED}"/usr/include || die
	#rm "${ED}"/usr/share/info/remake.info* || die
}
