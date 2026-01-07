# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools bash-completion-r1 elisp-common

DESCRIPTION="2- and 3-D plotter for creating images (to be used in LaTeX)"
HOMEPAGE="https://mathcs.holycross.edu/~ahwang/current/ePiX.html"
SRC_URI="https://mathcs.holycross.edu/~ahwang/epix/${P}_withpdf.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
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

PATCHES=( "${FILESDIR}"/${P}-autotools.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-epix-el
}

src_install() {
	default

	newbashcomp bash_completions epix
	bashcomp_alias epix flix elaps laps

	if use emacs; then
		# do compilation here as the make install target will
		# create the .el file
		elisp-compile *.el
		elisp-install ${PN} *.elc *.el
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi

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
