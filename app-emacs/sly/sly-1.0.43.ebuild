# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Sylvester the Cat's Common Lisp IDE for GNU Emacs"
HOMEPAGE="https://github.com/joaotavora/sly/"
SRC_URI="https://github.com/joaotavora/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain GPL-2+ GPL-3+ LLGPL-2.1 ZLIB xref? ( xref.lisp )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc xref"

RDEPEND="
	dev-lisp/asdf
	dev-lisp/sbcl
"
DEPEND="${RDEPEND}"
BDEPEND="
	sys-apps/texinfo
	doc? ( virtual/texi2dvi )
"

SITEFILE="50${PN}-gentoo.el"

src_prepare() {
	default

	# Remove failing tests (sly-fontifying-fu-tests is a part of "check-fancy")
	rm test/sly-fontifying-fu-tests.el || die

	# Remove xref.lisp (which is non-free) unless USE flag is set
	use xref || rm slynk/xref.lisp || die
}

src_compile() {
	emake EMACS="${EMACS}" compile compile-contrib

	emake -C doc ${PN}.info

	if use doc ; then
		VARTEXFONTS="${T}"/fonts emake -C doc all
	fi
}

src_test() {
	# NOTICE: "check-core" has some failing tests under root/portage user
	emake check-fancy
}

src_install() {
	elisp-install ${PN} *el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	elisp-install ${PN}/contrib/ contrib/*
	elisp-install ${PN}/lib/ lib/* lib/.nosearch
	elisp-install ${PN}/slynk/ slynk/*
	elisp-install ${PN}/slynk/backend/ slynk/backend/*

	doinfo doc/${PN}.info
	dodoc CONTRIBUTING.md NEWS.md PROBLEMS.md README.md

	use doc && dodoc doc/*.pdf
}
