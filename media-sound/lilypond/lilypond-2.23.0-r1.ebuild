# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{9..10} )

inherit elisp-common autotools python-single-r1 toolchain-funcs xdg-utils

if [[ "${PV}" = "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.savannah.gnu.org/git/lilypond.git"
else
	MAIN_VER=$(ver_cut 1-2)
	SRC_URI="http://lilypond.org/download/sources/v${MAIN_VER}/${P}.tar.gz"
	KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~x86"
fi

DESCRIPTION="GNU Music Typesetter"
HOMEPAGE="http://lilypond.org/"

LICENSE="GPL-3 FDL-1.3"
SLOT="0"
LANG_USE="l10n_ca l10n_cs l10n_de l10n_en l10n_fr l10n_hu l10n_it l10n_ja l10n_nl l10n_pt l10n_zh"
IUSE="debug doc emacs profile vim-syntax ${LANG_USE}"
unset LANG_USE
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	dev-texlive/texlive-metapost
	sys-apps/texinfo
	sys-devel/bison
	sys-devel/flex
	virtual/pkgconfig
	doc? ( app-text/texi2html )
"
RDEPEND="app-text/ghostscript-gpl
	dev-scheme/guile:12=[deprecated,regex]
	media-fonts/tex-gyre
	media-libs/fontconfig
	media-libs/freetype:2
	x11-libs/pango
	emacs? ( >=app-editors/emacs-23.1:* )
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-text/t1utils
	dev-lang/perl
	dev-libs/kpathsea
	media-gfx/fontforge[png,python]
	sys-devel/gettext
	doc? (
		dev-texlive/texlive-langcyrillic
		l10n_cs? ( dev-texlive/texlive-xetex )
		l10n_ja? ( dev-texlive/texlive-langjapanese )
		l10n_zh? ( dev-texlive/texlive-langchinese )
	)
"
# Correct output data for tests isn't bundled with releases
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${P}-fix-font-size.patch
	"${FILESDIR}"/${PN}-2.22.1-free_font.patch
)

DOCS=( DEDICATION HACKING README.md ROADMAP )

src_prepare() {
	default

	if ! use vim-syntax ; then
		sed -i 's/vim//' GNUmakefile.in || die
	fi

	# respect CFLAGS
	sed -i 's/OPTIMIZE -g/OPTIMIZE/' aclocal.m4 || die

	# remove bundled texinfo file (fixes bug #448560)
	rm tex/texinfo.tex || die

	eautoreconf

	xdg_environment_reset #586592
}

src_configure() {
	# fix hardcoded `ar`
	sed -i "s/AR=ar/AR=$(tc-getAR)/g" flower/GNUmakefile || die "Failed to fix ar command"

	local myeconfargs=(
		--with-texgyre-dir=/usr/share/fonts/tex-gyre
		--disable-optimising
		--disable-pipe
		$(use_enable debug debugging)
		$(use_enable doc documentation)
		$(use_enable profile profiling)
	)

	export VARTEXFONTS="${T}/fonts"  # https://bugs.gentoo.org/692010

	econf "${myeconfargs[@]}" AR="$(tc-getAR)"
}

src_compile() {
	default

	use doc && emake LANGS="${L10N}" doc info

	if use emacs ; then
		elisp-compile elisp/lilypond-{font-lock,indent,mode,what-beat}.el \
			|| die "elisp-compile failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" vimdir=/usr/share/vim/vimfiles install

	use doc && emake DESTDIR="${D}" install-doc

	# remove elisp files since they are in the wrong directory
	rm -r "${ED}"/usr/share/emacs || die

	if use emacs ; then
		elisp-install ${PN} elisp/*.{el,elc} elisp/out/*.el \
			|| die "elisp-install failed"
		elisp-site-file-install "${FILESDIR}"/50${PN}-gentoo.el
	fi

	python_fix_shebang "${ED}"

	einstalldocs
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
