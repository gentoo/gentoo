# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Debian Almquist Shell"
HOMEPAGE="http://gondor.apana.org.au/~herbert/dash/"
if [[ ${PV} == 9999 ]] ; then
	EGIT_REPO_URI="https://git.kernel.org/pub/scm/utils/dash/dash.git"
	inherit autotools git-r3
else
	SRC_URI="http://gondor.apana.org.au/~herbert/dash/files/${P}.tar.gz"
	KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~arm64-macos ~ppc-macos ~x64-macos ~x64-solaris"
fi

LICENSE="BSD"
SLOT="0"
IUSE="libedit static"

BDEPEND="virtual/pkgconfig"
RDEPEND="!static? ( libedit? ( dev-libs/libedit ) )"
DEPEND="
	${RDEPEND}
	libedit? ( static? ( dev-libs/libedit[static-libs] ) )
"

PATCHES=(
	"${FILESDIR}"/${P}-c23.patch
	"${FILESDIR}"/${PN}-0.5.12-c23-lto.patch
)

src_prepare() {
	default

	[[ ${PV} == 9999 ]] && eautoreconf

	# Use pkg-config for libedit linkage
	sed -i \
		-e "/LIBS/s:-ledit:\`$(tc-getPKG_CONFIG) --libs libedit $(usex static --static '')\`:" \
		configure || die
}

src_configure() {
	if [[ ${CHOST} == *-solaris* ]] ; then
		# don't redefine stat, open, dirent, etc. on Solaris
		export ac_cv_func_stat64=yes
		export ac_cv_func_open64=yes
	fi

	if [[ ${CHOST} == powerpc-*-darwin* ]] ; then
		sed -i -e 's/= stpncpy(s, \([^,]\+\), \([0-9]\+\))/+= snprintf(s, \2, "%s", \1)/' \
			src/jobs.c || die
	fi

	use static && append-ldflags -static

	append-cppflags -DJOBS=$(usex libedit 1 0)

	# Do not pass --enable-glob due to #443552.
	local myeconfargs=(
		CC_FOR_BUILD="$(tc-getBUILD_CC)"
		--bindir="${EPREFIX}"/bin
		--enable-fnmatch
		$(use_with libedit)
	)

	econf "${myeconfargs[@]}"
}
