# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH=/usr/share/openpgp-keys/groff.asc
inherit toolchain-funcs verify-sig

MY_P="${P/_/.}"
DESCRIPTION="Text formatter used for man pages"
HOMEPAGE="https://www.gnu.org/software/groff/groff.html"

if [[ ${PV} == *_rc* ]] ; then
	SRC_URI="
		https://alpha.gnu.org/gnu/groff/${MY_P}.tar.gz
		verify-sig? ( https://alpha.gnu.org/gnu/groff/${MY_P}.tar.gz.sig )
	"
else
	SRC_URI="
		mirror://gnu/groff/${MY_P}.tar.gz
		verify-sig? ( mirror://gnu/groff/${MY_P}.tar.gz.sig )
	"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~arm64-macos ~x64-macos ~x64-solaris"
fi

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
IUSE="examples postscript uchardet X"

# ghostscript-gpl:= for font paths (bug #962804)
DEPEND="
	uchardet? ( app-i18n/uchardet )
	postscript? (
		>=app-text/ghostscript-gpl-9.54:=
		app-text/psutils
		media-libs/netpbm
	)
	X? (
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXaw
		x11-libs/libXmu
		x11-libs/libXt
	)
"
RDEPEND="
	${DEPEND}
	media-fonts/urw-fonts
"
BDEPEND="
	>=dev-lang/perl-5.8
	>=sys-apps/texinfo-5.0
	sys-devel/m4
	postscript? (
		>=app-text/ghostscript-gpl-9.54
		app-text/psutils
		media-libs/netpbm
	)
	verify-sig? ( sec-keys/openpgp-keys-groff )
"

DOCS=( BUG-REPORT ChangeLog MORE.STUFF NEWS PROBLEMS PROJECTS README TODO )

PATCHES=(
	# bug #16108, bug #17580, bug #121502
	"${FILESDIR}"/${PN}-1.19.2-man-unicode-dashes.patch
)

src_prepare() {
	default

	# Honor Gentoo's docdir
	sed -i -e "s|^docdir =.*|docdir = \"${EPREFIX}/usr/share/doc/${PF}\"|g" \
		Makefile.in \
		|| die "failed to modify Makefile.in"

	local pfx=$(usev prefix ' Prefix')
	cat <<-EOF >> tmac/mdoc.local || die
	.ds volume-operating-system Gentoo${pfx}
	.ds operating-system Gentoo${pfx}/${KERNEL}
	.ds default-operating-system Gentoo${pfx}/${KERNEL}
	EOF

	# make sure we don't get a crappy `g' nameprefix on UNIX systems with real
	# troff (GROFF_G macro runs some test to see, its own troff doesn't satisfy)
	sed -i -e 's/^[ \t]\+g=g$/g=/' configure || die
}

src_configure() {
	if ! use postscript ; then
		export ac_cv_prog_XPMTOPPM=missing
		export GHOSTSCRIPT=missing
		export ac_cv_prog_ac_ct_GHOSTSCRIPT=missing
		export ac_cv_prog_pamcut=missing
		export ac_cv_prog_pnmcrop=missing
		export ac_cv_prog_pnmtopng=missing
		export ac_cv_prog_pnmtops=missing
		export ac_cv_prog_ps2ps=found
	fi

	local myeconfargs=(
		--with-appdefdir="${EPREFIX}"/usr/share/X11/app-defaults
		--without-compatibility-wrappers # for Prefix
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

	# .ms, .ps files shouldn't be compressed and other files are tiny (bug #542624)
	while IFS= read -r -d ''; do
		docompress -x ${REPLY#${ED}}
	done < <(find "${ED}"/usr/share/doc/${PF} -type f \( -name '*.me' -or -name '*.ms' -o -name '*.ps' \) -print0 || die)

	# The following links are required for man (bug #123674)
	dosym eqn /usr/bin/geqn
	dosym tbl /usr/bin/gtbl

	if ! use examples ; then
		# The pdf files might not be generated if ghostscript is unavailable (bug #602020)
		local pdf="${ED}/usr/share/doc/${PF}/examples/mom/mom-pdf.pdf"
		if [[ -e ${pdf} ]] ; then
			# Keep mom-pdf.pdf since it's more of a manual than an example
			# bug #454196 and bug #516732
			mv "${pdf}" "${ED}/usr/share/doc/${PF}/pdf/" || die
		fi
		rm -rf "${ED}/usr/share/doc/${PF}/examples"
	fi
}
