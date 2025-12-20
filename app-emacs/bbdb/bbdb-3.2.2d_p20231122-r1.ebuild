# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp autotools

DESCRIPTION="The Insidious Big Brother Database"
HOMEPAGE="https://savannah.nongnu.org/projects/bbdb/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://git.savannah.nongnu.org/cgit/${PN}.git"
else
	COMMIT="53e8ba04c47b3542db75b68f9663941daf2e6ca4"
	SRC_URI="https://git.savannah.nongnu.org/cgit/bbdb.git/snapshot/${PN}-${COMMIT}.tar.gz
		-> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"
fi

LICENSE="GPL-3+ FDL-1.3"
SLOT="0"
IUSE="doc tex vm wanderlust"
RESTRICT="test"                                                    # bug 631700

RDEPEND="
	vm? ( app-emacs/vm )
	wanderlust? ( app-emacs/wanderlust )
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
	doc? ( virtual/texi2dvi )
"
IDEPEND="
	tex? ( virtual/latex-base )
"

PATCHES=( "${FILESDIR}/${P}-loaddefs.patch" )
SITEFILE="50${PN}-gentoo-3.2.el"
TEXMF="/usr/share/texmf-site"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local -a -r econfargs=(
		--with-lispdir="${EPREFIX}${SITELISP}/${PN}"
		"$(use_with vm vm-dir "${EPREFIX}${SITELISP}/vm")"
		"$(use_with wanderlust wl-dir "${EPREFIX}${SITELISP}/wl")"
	)
	econf "${econfargs[@]}"
}

src_compile() {
	emake -C lisp
	emake -C doc info $(usev doc pdf)
}

src_install() {
	emake -C lisp DESTDIR="${D}" install
	emake -C doc DESTDIR="${D}" install-info $(usev doc install-pdf)
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	if use tex; then
		insinto "${TEXMF}/tex/latex/${PN}"
		doins tex/bbdb.sty
	fi

	dodoc AUTHORS ChangeLog NEWS README TODO
}

pkg_postinst() {
	elisp-site-regen
	use tex && texconfig rehash
}

pkg_postrm() {
	elisp-site-regen
	use tex && texconfig rehash
}
