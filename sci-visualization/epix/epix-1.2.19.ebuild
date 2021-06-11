# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp-common bash-completion-r1 autotools

DESCRIPTION="2- and 3-D plotter for creating images (to be used in LaTeX)"
HOMEPAGE="https://mathcs.holycross.edu/~ahwang/current/ePiX.html"
SRC_URI="https://mathcs.holycross.edu/~ahwang/epix/${P}_withpdf.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~ppc ~x86 ~amd64-linux ~x86-linux"
IUSE="doc emacs examples"

DEPEND="
	virtual/latex-base
	dev-texlive/texlive-pstricks
	dev-texlive/texlive-pictures
	dev-texlive/texlive-latexextra
	dev-texlive/texlive-latexrecommended
	emacs? ( >=app-editors/emacs-23.1:* )"
RDEPEND="${DEPEND}"
SITEFILE=50${PN}-gentoo.el

PATCHES=(
	"${FILESDIR}/${P}-autotools.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--disable-epix-el
}

src_install() {
	default
	if use emacs; then
		# do compilation here as the make install target will
		# create the .el file
		elisp-compile *.el || die "elisp-compile failed!"
		elisp-install ${PN} *.elc *.el || die "elisp-install failed!"
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
	newbashcomp bash_completions epix
	bashcomp_alias epix flix elaps laps
	if use doc; then
		dodoc doc/*gz
		docompress -x /usr/share/doc/${PF}/manual{.pdf,.ps,_src.tar}.gz
	fi
	if use examples; then
		cd samples || die
		docinto examples
		dodoc *.xp *.flx *c *h README
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
