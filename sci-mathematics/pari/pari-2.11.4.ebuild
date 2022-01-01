# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Computer-aided number theory C library and tools"
HOMEPAGE="https://pari.math.u-bordeaux.fr/"
SRC_URI="https://pari.math.u-bordeaux.fr/pub/${PN}/unix/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/6"
KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~x86-macos ~x86-solaris"
IUSE="data doc fltk gmp test threads X"
RESTRICT="!test? ( test )"

BDEPEND="doc? ( virtual/latex-base )"
DEPEND="
	sys-libs/readline:0=
	data? ( sci-mathematics/pari-data )
	doc? ( X? ( x11-misc/xdg-utils ) )
	fltk? ( x11-libs/fltk:1= )
	gmp? ( dev-libs/gmp:0= )
	X? ( x11-libs/libX11:0= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}"-2.9.4-strip.patch
	"${FILESDIR}/${PN}"-2.9.4-ppc.patch
	"${FILESDIR}/${PN}"-2.11.2-no-automagic.patch
	"${FILESDIR}/${PN}"-2.9.4-fltk-detection.patch
	"${FILESDIR}/${PN}"-2.11.2-Makefile-LDFLAGS.patch
	"${FILESDIR}/${PN}"-2.11.2-Makefile-docinstall.patch
)

DOCS=( AUTHORS CHANGES* COMPAT NEW README* )

src_prepare() {
	default

	# move doc dir to a gentoo doc dir and replace acroread by xdg-open
	sed -i \
		-e "s:\$d = \$0:\$d = '${EPREFIX}/usr/share/doc/${PF}':" \
		-e 's:"acroread":"xdg-open":' \
		doc/gphelp.in || die "Failed to fix doc dir"
}

src_configure() {
	tc-export CC CXX

	# Workaraound to "asm operand has impossible constraints" as
	# suggested in bug #499996.
	use x86 && append-cflags $(test-flags-CC -fno-stack-check)

	# need to force optimization here, as it breaks without
	if is-flag -O0; then
		replace-flags -O0 -O2
	elif ! is-flag -O?; then
		append-flags -O2
	fi

	# sysdatadir installs a pari.cfg stuff which is informative only.
	# It is supposed to be for "architecture-dependent" data.
	# It needs to be easily discoverable for downstream packages such as gp2c.
	./Configure \
		--prefix="${EPREFIX}"/usr \
		--datadir="${EPREFIX}/usr/share/${PN}" \
		--libdir="${EPREFIX}/usr/$(get_libdir)" \
		--sysdatadir="${EPREFIX}"/usr/share/pari \
		--mandir="${EPREFIX}"/usr/share/man/man1 \
		--with-readline="${EPREFIX}"/usr \
		--with-readline-lib="${EPREFIX}/usr/$(get_libdir)" \
		--with-ncurses-lib="${EPREFIX}/usr/$(get_libdir)" \
		$(use_with fltk) \
		$(use_with gmp) \
		--without-qt \
		$(usex threads "--mt=pthread" "" "" "") \
		|| die "./Configure failed"
}

src_compile() {
	local mymake=""
	use hppa && \
		mymake=DLLD\="${EPREFIX}"/usr/bin/gcc\ DLLDFLAGS\=-shared\ -Wl,-soname=\$\(LIBPARI_SONAME\)\ -lm

	emake ${mymake} gp

	if use doc; then
		# To prevent sandbox violations by metafont
		VARTEXFONTS="${T}/fonts" emake docpdf
	fi
}

src_test() {
	# Welcome to the jungle, where the tests fail if you make your
	# terminal bigger.
	emake COLUMNS=80 test-all
}

src_install() {
	default

	if use doc; then
		docompress -x "/usr/share/doc/${PF}"
		emake \
			DESTDIR="${D}" \
			EXDIR="${ED}/usr/share/doc/${PF}/examples" \
			DOCDIR="${ED}/usr/share/doc/${PF}" \
			install-doc
	fi
}
