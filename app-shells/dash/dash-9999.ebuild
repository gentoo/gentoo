# Copyright 1999-2026 Gentoo Authors
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
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
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

src_prepare() {
	default

	[[ ${PV} == 9999 ]] && eautoreconf

	# Use pkg-config for libedit linkage
	sed -i \
		-e "/LIBS/s:-ledit:\`$(tc-getPKG_CONFIG) --libs libedit $(usex static --static '')\`:" \
		configure || die

	if [[ ${CHOST} == *-solaris* ]] ; then
		# Solaris doesn't have dirent->d_type
		eapply "${FILESDIR}"/dash-0.5.13-revert-d_type-solaris.patch
	fi
}

src_configure() {
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
