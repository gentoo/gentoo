# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

[[ "${PV}" = "9999" ]] && inherit git-r3
inherit elisp-common autotools python-single-r1

if [[ "${PV}" = "9999" ]]; then
	EGIT_REPO_URI="git://git.sv.gnu.org/lilypond.git"
else
	SRC_URI="http://download.linuxaudio.org/lilypond/sources/v${PV:0:4}/${P}.tar.gz"
	KEYWORDS="~amd64 ~hppa ~x86"
fi

DESCRIPTION="GNU Music Typesetter"
HOMEPAGE="http://lilypond.org/"

LICENSE="GPL-3 FDL-1.3"
SLOT="0"
LANGS=" ca cs da de el eo es fi fr it ja nl ru sv tr uk vi zh_TW"
IUSE="debug emacs profile vim-syntax ${LANGS// / linguas_}"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND=">=app-text/ghostscript-gpl-8.15
	>=dev-scheme/guile-1.8.2:12[deprecated,regex]
	media-fonts/tex-gyre
	media-libs/fontconfig
	media-libs/freetype:2
	>=x11-libs/pango-1.12.3
	emacs? ( virtual/emacs )
	${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-text/t1utils
	dev-lang/perl
	dev-libs/kpathsea
	>=dev-texlive/texlive-metapost-2013
	|| (
		>=app-text/texlive-core-2013
		>=dev-tex/metapost-1.803
	)
	virtual/pkgconfig
	media-gfx/fontforge[png]
	>=sys-apps/texinfo-4.11
	>=sys-devel/bison-2.0
	sys-devel/flex
	sys-devel/gettext
	sys-devel/make"

# Correct output data for tests isn't bundled with releases
RESTRICT="test"

DOCS=( README.txt )

pkg_setup() {
	# make sure >=metapost-1.803 is selected if it's installed, bug 498704
	if [[ ${MERGE_TYPE} != binary ]] && has_version ">=dev-tex/metapost-1.803" ; then
		if [[ $(readlink "${EROOT}"/usr/bin/mpost) =~ mpost-texlive-* ]] ; then
			einfo "Updating metapost symlink"
			eselect mpost update || die
		fi
	fi

	python-single-r1_pkg_setup
}

src_prepare() {
	if ! use vim-syntax ; then
		sed -i 's/vim//' GNUmakefile.in || die
	fi

	# respect CFLAGS
	sed -i 's/OPTIMIZE -g/OPTIMIZE/' aclocal.m4 || die

	for lang in ${LANGS}; do
		use linguas_${lang} || rm po/${lang}.po || die
	done

	# respect AR
	sed -i "s/^AR=ar/AR=$(tc-getAR)/" stepmake/stepmake/library-vars.make || die

	# remove bundled texinfo file (fixes bug #448560)
	rm tex/texinfo.tex || die

	eapply_user

	eautoreconf
}

src_configure() {
	# documentation generation currently not supported since it requires a newer
	# version of texi2html than is currently in the tree

	econf \
		--with-texgyre-dir=/usr/share/fonts/tex-gyre \
		--disable-documentation \
		--disable-optimising \
		--disable-pipe \
		$(use_enable debug debugging) \
		$(use_enable profile profiling)
}

src_compile() {
	default

	if use emacs ; then
		elisp-compile elisp/lilypond-{font-lock,indent,mode,what-beat}.el \
			|| die "elisp-compile failed"
	fi
}

src_install () {
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
