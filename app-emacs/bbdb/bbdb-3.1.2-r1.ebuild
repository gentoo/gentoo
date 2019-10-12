# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit elisp autotools

DESCRIPTION="The Insidious Big Brother Database"
HOMEPAGE="https://savannah.nongnu.org/projects/bbdb/"
SRC_URI="http://download.savannah.gnu.org/releases/${PN}/${P}.tar.gz"

LICENSE="GPL-3+ GPL-1+ FDL-1.3+"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE="tex vm"
RESTRICT="test" #631700

BDEPEND="vm? ( app-emacs/vm )"
RDEPEND="${BDEPEND}
	tex? ( virtual/tex-base )"

SITEFILE="50${PN}-gentoo-${PV}.el"
TEXMF="/usr/share/texmf-site"

src_prepare() {
	eapply "${FILESDIR}"/${P}-no-init.patch
	eapply_user
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
	doinfo doc/*.info*
	dodoc AUTHORS ChangeLog NEWS README TODO

	if use tex; then
		insinto "${TEXMF}"/tex/plain/${PN}
		doins tex/*.tex
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
