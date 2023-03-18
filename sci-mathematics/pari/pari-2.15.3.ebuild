# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic toolchain-funcs

DESCRIPTION="Computer-aided number theory C library and tools"
HOMEPAGE="https://pari.math.u-bordeaux.fr/"
SRC_URI="https://pari.math.u-bordeaux.fr/pub/${PN}/unix/${P}.tar.gz"

LICENSE="GPL-2"

# The subslot is the value of $soname_num obtained from
# upstream's config/version script.
SLOT="0/8"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="data doc examples fltk gmp test threads X"
RESTRICT="!test? ( test )"

BDEPEND="
	virtual/pkgconfig
	doc? ( virtual/latex-base )
"
DEPEND="
	sys-libs/readline:0=
	data? ( sci-mathematics/pari-data )
	doc? ( X? ( x11-misc/xdg-utils ) )
	fltk? ( x11-libs/fltk:1= )
	gmp? ( dev-libs/gmp:0= )
	X? ( x11-libs/libX11:0= )"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}"-2.9.4-ppc.patch
	"${FILESDIR}/${PN}"-2.9.4-fltk-detection.patch
	"${FILESDIR}/${PN}"-2.11.2-no-automagic.patch
)

src_prepare() {
	default

	# move doc dir to a gentoo doc dir and replace acroread by xdg-open
	sed -i \
		-e "s:\$d = \$0:\$d = '${EPREFIX}/usr/share/doc/${PF}':" \
		-e 's:"acroread":"xdg-open":' \
		doc/gphelp.in || die "Failed to fix doc dir"

	# These tests fail when LaTeX is not installed (which we don't
	# require without USE=doc), most likely due to output formatting
	# issues but I haven't deleted my LaTeX installation to check.
	# There's no real upstream support for enabling/disabling the LaTeX
	# docs, so this is probably the correctest way to skip these tests.
	if ! use doc; then
		rm src/test/{in,32}/help || die
	fi
}

src_configure() {
	tc-export CC CXX PKG_CONFIG

	# Workaraound to "asm operand has impossible constraints" as
	# suggested in bug #499996.
	use x86 && append-cflags $(test-flags-CC -fno-stack-check)

	# sysdatadir installs a pari.cfg stuff which is informative only.
	# It is supposed to be for "architecture-dependent" data.  It needs
	# to be easily discoverable for downstream packages such as gp2c.
	# We set LD="" and DLLD="$CC" so that the "shared library linker"
	# always gets set to the value of the compiler used. Pari's build
	# system does not cope very well with a naked linker, it is
	# expecting a compiler driver. See bugs 722090 and 871117.
	# DLLDFLAGS, on the other hand, is used exactly like LDFLAGS would
	# be in a less-weird build system.
	LD="" DLLD="$(tc-getCC)" DLLDFLAGS="${LDFLAGS}" ./Configure \
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
	emake gp

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
	DOCS=( AUTHORS CHANGES* COMPAT NEW README* )

	# Install examples to a junk location by default because "make
	# install-nodata" includes the examples with it. Only if the user
	# has USE=examples set do we provide the correct directory.
	local exdir="${T}"
	if use examples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		exdir="${ED}/usr/share/doc/${PF}/examples"
	fi

	# Use "true" in place of "strip" to sabotage the unconditional
	# binary stripping.
	emake DESTDIR="${D}" \
		  EXDIR="${exdir}" \
		  STRIP="true" \
		  install-nodata install-data
	einstalldocs

	if use doc; then
		docompress -x "/usr/share/doc/${PF}"
		emake \
			DESTDIR="${D}" \
			DOCDIR="${ED}/usr/share/doc/${PF}" \
			install-docpdf install-doctex
	fi
}
