# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Debian Almquist Shell"
HOMEPAGE="http://gondor.apana.org.au/~herbert/dash/"
SRC_URI="http://gondor.apana.org.au/~herbert/dash/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="libedit static"

BDEPEND="virtual/pkgconfig"
RDEPEND="!static? ( libedit? ( dev-libs/libedit ) )"
DEPEND="${RDEPEND}
	libedit? ( static? ( dev-libs/libedit[static-libs] ) )"

PATCHES=(
	"${FILESDIR}/dash-0.5.9.1-format-security.patch"
	"${FILESDIR}/dash-0.5.20.2-gcc-fno-common.patch"
)

src_prepare() {
	default

	# Fix the invalid sort
	sed -i -e 's/LC_COLLATE=C/LC_ALL=C/g' src/mkbuiltins

	# Use pkg-config for libedit linkage
	sed -i \
		-e "/LIBS/s:-ledit:\`$(tc-getPKG_CONFIG) --libs libedit $(usex static --static '')\`:" \
		configure || die
}

src_configure() {
	# don't redefine stat on Solaris
	if [[ ${CHOST} == *-solaris* ]] ; then
		export ac_cv_func_stat64=yes

		# if your headers strictly adhere to POSIX, you'll need this too
		[[ ${CHOST##*solaris2.} -le 10 ]] && append-cppflags -DNAME_MAX=255
	fi
	append-cppflags -DJOBS=$(usex libedit 1 0)
	use static && append-ldflags -static
	# Do not pass --enable-glob due to #443552.
	local myeconfargs=(
		--bindir="${EPREFIX}"/bin
		--enable-fnmatch
		$(use_with libedit)
	)
	econf "${myeconfargs[@]}"
}
