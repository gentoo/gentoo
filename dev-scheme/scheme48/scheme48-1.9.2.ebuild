# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit elisp-common multilib eutils flag-o-matic

DESCRIPTION="Scheme48 is an implementation of the Scheme Programming Language"
HOMEPAGE="http://www.s48.org/"
SRC_URI="http://www.s48.org/${PV}/${P}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64 ~amd64-linux ~x86-linux ~x86-macos"
IUSE="doc emacs"

DEPEND="emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"
SITEFILE=50scheme48-gentoo.el

src_configure() {
	append-cflags -fno-strict-aliasing
	econf --docdir=/usr/share/doc/${P}
}

src_compile() {
	emake
	if use emacs; then
		elisp-compile "${S}"/emacs/cmuscheme48.el
	fi
}

src_install() {
	# weird parallel failures!
	emake -j1 DESTDIR="${D}" install

	if use emacs; then
		elisp-install ${PN} emacs/cmuscheme48.el emacs/*.elc
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	dodoc README
	if use doc; then
		dodoc doc/*.txt
		docinto src
		dodoc doc/src/*
		pushd "${ED}/usr/share/doc/${P}" > /dev/null
		install -dm755 html
		mv *.html *.css *.gif html/
		popd > /dev/null
	else
		pushd "${ED}/usr/share/doc/${P}" > /dev/null
		rm -f *.html *.css *.gif
		rm -f manu*
		popd > /dev/null
	fi

	#this symlink clashes with gambit
	rm "${ED}"/usr/bin/scheme-r5rs || die
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
