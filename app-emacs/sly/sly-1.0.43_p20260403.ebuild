# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit elisp

DESCRIPTION="Sylvester the Cat's Common Lisp IDE for GNU Emacs"
HOMEPAGE="https://github.com/joaotavora/sly/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3

	EGIT_REPO_URI="https://github.com/joaotavora/${PN}"
else
	[[ "${PV}" == *20260403 ]] && COMMIT="759c0ff8741ced8793257f2b7ed95a23e13e1407"

	SRC_URI="https://github.com/joaotavora/${PN}/archive/${COMMIT}.tar.gz
		-> ${P}.snapshot.gh.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT}"

	KEYWORDS="~amd64 ~x86"
fi

LICENSE="public-domain GPL-2+ GPL-3+ LLGPL-2.1 ZLIB xref? ( xref.lisp )"
SLOT="0"
IUSE="doc xref"

RDEPEND="
	dev-lisp/asdf
	dev-lisp/sbcl
"
BDEPEND="
	${RDEPEND}
	sys-apps/texinfo
	doc? (
		virtual/texi2dvi
	)
"

# Remove failing tests (sly-fontifying-fu-tests is a part of "check-fancy")
ELISP_REMOVE="
	test/sly-fontifying-fu-tests.el
"

DOCS=( CONTRIBUTING.md NEWS.md PROBLEMS.md README.md )
SITEFILE="50${PN}-gentoo-r1.el"

src_prepare() {
	elisp_src_prepare

	# Remove xref.lisp (which is non-free) unless USE flag is set
	if ! use xref ; then
		rm slynk/xref.lisp || die
	fi
}

src_compile() {
	emake EMACS="${EMACS}" compile
	emake EMACS="${EMACS}" compile-contrib

	# Regen the vendored autoloads.
	elisp-make-autoload-file "${PN}-autoloads.el" ./ ./lib/

	emake -C ./doc/ "${PN}.info"

	if use doc ; then
		VARTEXFONTS="${T}/fonts" emake -C doc all
	fi
}

src_test() {
	# NOTICE: "check-core" has some failing tests under root/portage user
	emake check-fancy
}

src_install() {
	elisp-install "${PN}" *.el{,c}
	elisp-site-file-install "${FILESDIR}/${SITEFILE}"

	elisp-install "${PN}/contrib/" ./contrib/*
	elisp-install "${PN}/lib/" ./lib/* ./lib/.nosearch
	elisp-install "${PN}/slynk/" ./slynk/*
	elisp-install "${PN}/slynk/backend/" ./slynk/backend/*

	einstalldocs
	doinfo "./doc/${PN}.info"

	if use doc ; then
		dodoc ./doc/*.pdf
	fi
}
