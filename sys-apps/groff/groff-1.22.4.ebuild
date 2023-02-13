# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

MY_P="${P/_/.}"

DESCRIPTION="Text formatter used for man pages"
HOMEPAGE="https://www.gnu.org/software/groff/groff.html"
SRC_URI="mirror://gnu/groff/${MY_P}.tar.gz
	https://alpha.gnu.org/gnu/groff/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
[[ "${PV}" == *_rc* ]] || \
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="examples uchardet X"

RDEPEND="
	uchardet? ( app-i18n/uchardet )
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXmu
		x11-libs/libXt
	)"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-lang/perl
	sys-apps/texinfo"

DOCS=( BUG-REPORT ChangeLog MORE.STUFF NEWS PROBLEMS PROJECTS README TODO )

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.19.2-man-unicode-dashes.patch #16108 #17580 #121502
	"${FILESDIR}"/${PN}-1.22.4-skip-broken-diffutils-test.patch
)

src_prepare() {
	default

	# honor Gentoo's docdir
	sed -i -e "s|^docdir =.*|docdir = \"${EPREFIX}/usr/share/doc/${PF}\"|g" \
		Makefile.in \
		|| die "failed to modify Makefile.in"

	local pfx=$(usex prefix ' Prefix' '')
	cat <<-EOF >> tmac/mdoc.local
	.ds volume-operating-system Gentoo${pfx}
	.ds operating-system Gentoo${pfx}/${KERNEL}
	.ds default-operating-system Gentoo${pfx}/${KERNEL}
	EOF

	# make sure we don't get a crappy `g' nameprefix on UNIX systems with real
	# troff (GROFF_G macro runs some test to see, its own troff doesn't satisfy)
	sed -i -e 's/^[ \t]\+g=g$/g=/' configure || die
}

src_configure() {
	if use elibc_musl ; then
		# This should be safe to drop in the release after 1.22.4
		# gnulib was rather out of date and didn't include musl in its
		# CHOST checks.
		# bug #678026
		export gl_cv_func_signbit_gcc=yes
	fi

	# Drop in release after 1.22.4! bug #894154
	append-cxxflags -std=gnu++11

	local myeconfargs=(
		--with-appresdir="${EPREFIX}"/usr/share/X11/app-defaults
		$(use_with uchardet)
		$(use_with X x)
	)
	econf "${myeconfargs[@]}"
}

src_compile() {
	local -a CROSS_ARGS
	tc-is-cross-compiler && CROSS_ARGS+=(
		GROFFBIN="$(type -P groff)"
		TROFFBIN="$(type -P troff)"
		GROFF_BIN_DIR=
		GROFF_BIN_PATH=
	)

	emake AR="$(tc-getAR)" "${CROSS_ARGS[@]}"
}

src_install() {
	default

	# The following links are required for man #123674
	dosym eqn /usr/bin/geqn
	dosym tbl /usr/bin/gtbl

	if ! use examples ; then
		# The pdf files might not be generated if ghostscript is unavailable. #602020
		local pdf="${ED}/usr/share/doc/${PF}/examples/mom/mom-pdf.pdf"
		if [[ -e ${pdf} ]] ; then
			# Keep mom-pdf.pdf since it's more of a manual than an example. #454196 #516732
			mv "${pdf}" "${ED}/usr/share/doc/${PF}/pdf/" || die
		fi
		rm -rf "${ED}/usr/share/doc/${PF}/examples"
	fi
}
