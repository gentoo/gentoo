# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp autotools

MY_P="${P%_pre*}"
DESCRIPTION="The Insidious Big Brother Database"
HOMEPAGE="https://savannah.nongnu.org/projects/bbdb/"
#SRC_URI="https://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz"
SRC_URI="https://git.savannah.nongnu.org/cgit/bbdb.git/snapshot/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-3+ GPL-1+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="tex vm"
RESTRICT="test" #631700

BDEPEND="vm? ( app-emacs/vm )"
RDEPEND="${BDEPEND}
	tex? ( virtual/latex-base )"

SITEFILE="50${PN}-gentoo-3.2.el"
TEXMF="/usr/share/texmf-site"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--with-lispdir="${EPREFIX}${SITELISP}/${PN}" \
		"$(use_with vm vm-dir "${EPREFIX}${SITELISP}/vm")"
}

src_compile() {
	emake -C lisp
}

src_install() {
	emake -C lisp DESTDIR="${D}" install
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	dodoc AUTHORS ChangeLog NEWS README TODO

	if use tex; then
		insinto "${TEXMF}"/tex/latex/${PN}
		doins tex/bbdb.sty
	fi
}

pkg_postinst() {
	elisp-site-regen
	use tex && texconfig rehash
}

pkg_postrm() {
	elisp-site-regen
	use tex && texconfig rehash
}
