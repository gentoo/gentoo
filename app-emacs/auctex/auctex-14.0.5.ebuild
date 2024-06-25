# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools elisp

DESCRIPTION="Extensible package for writing and formatting TeX files in Emacs"
HOMEPAGE="https://www.gnu.org/software/auctex/
	https://git.savannah.gnu.org/cgit/auctex.git"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://git.savannah.gnu.org/git/${PN}.git"
else
	[[ "${PV}" == 14.0.5 ]] && COMMIT_SHA="e30189d92a701ab22a69a09fe2b9e9619fff6ce8"

	SRC_URI="https://git.savannah.gnu.org/cgit/${PN}.git/snapshot/${PN}-${COMMIT_SHA}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT_SHA}"

	KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
fi

LICENSE="GPL-3+ FDL-1.3+"
SLOT="0"
IUSE="preview-latex"

RDEPEND="
	virtual/latex-base
	preview-latex? (
		app-text/dvipng
		app-text/ghostscript-gpl
	)
"
BDEPEND="
	${RDEPEND}
"

TEXMF="/usr/share/texmf-site"

src_prepare() {
	elisp_src_prepare

	eautoreconf
}

src_configure() {
	local -a myconf=(
		--with-emacs
		--with-auto-dir="${EPREFIX}/var/lib/${PN}"
		--with-lispdir="${EPREFIX}${SITELISP}/${PN}"
		--with-packagelispdir="${EPREFIX}${SITELISP}/${PN}"
		--with-packagedatadir="${EPREFIX}${SITEETC}/${PN}"
		--with-texmf-dir="${EPREFIX}${TEXMF}"
		--disable-build-dir-test
		$(use_enable preview-latex preview)
	)
	econf "${myconf[@]}"
}

src_compile() {
	VARTEXFONTS="${T}/fonts" emake
}

src_install() {
	emake -j1 DESTDIR="${ED}" install
	elisp-site-file-install "${FILESDIR}/50${PN}-gentoo.el"

	if use preview-latex ; then
		elisp-site-file-install "${FILESDIR}/60${PN}-gentoo.el"
	fi

	dodoc ChangeLog* CHANGES FAQ INSTALL PROBLEMS.preview README RELEASE TODO
}

pkg_postinst() {
	use preview-latex && texmf-update

	elisp-site-regen
}

pkg_postrm() {
	use preview-latex && texmf-update

	elisp-site-regen
}
