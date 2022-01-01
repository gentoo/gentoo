# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6,7,8} )

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
IUSE="debug emacs guile2 profile vim-syntax"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

BDEPEND="
	>=dev-texlive/texlive-metapost-2020
	>=sys-apps/texinfo-4.11
	>=sys-devel/bison-2.0
	sys-devel/flex
	virtual/pkgconfig
"
RDEPEND=">=app-text/ghostscript-gpl-8.15
	>=dev-scheme/guile-1.8.2:12=[deprecated,regex]
	media-fonts/tex-gyre
	media-libs/fontconfig
	media-libs/freetype:2
	>=x11-libs/pango-1.12.3
	emacs? ( >=app-editors/emacs-23.1:* )
	guile2? ( >=dev-scheme/guile-2.2:12 )
	!guile2? (
		>=dev-scheme/guile-1.8.2:12=[deprecated,regex]
		<dev-scheme/guile-2.0:12
	)
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-text/t1utils
	dev-lang/perl
	dev-libs/kpathsea
	media-gfx/fontforge[png,python]
	sys-devel/gettext"

# Correct output data for tests isn't bundled with releases
RESTRICT="test"

PATCHES=(
	"${FILESDIR}"/${PN}-2.21.1-fix-font-size.patch
)

DOCS=( DEDICATION HACKING Documentation/out/topdocs/README.txt ROADMAP )

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
	# documentation generation currently not supported since it requires a newer
	# version of texi2html than is currently in the tree

	local myeconfargs=(
		--with-texgyre-dir=/usr/share/fonts/tex-gyre
		--disable-documentation
		--disable-optimising
		--disable-pipe
		$(use_enable debug debugging)
		$(use_enable profile profiling)
	)
	export VARTEXFONTS="${T}/fonts"  # https://bugs.gentoo.org/692010

	econf "${myeconfargs[@]}"
}

src_compile() {
	default

	if use emacs ; then
		elisp-compile elisp/lilypond-{font-lock,indent,mode,what-beat}.el \
			|| die "elisp-compile failed"
	fi
}

src_install() {
	emake DESTDIR="${D}" vimdir=/usr/share/vim/vimfiles install

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
