# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit elisp-common eutils multilib

MY_PN="${PN}-src"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Implementation of the logical framework LF"
HOMEPAGE="http://twelf.org/"
SRC_URI="http://twelf.plparty.org/releases/${MY_P}.tar.gz"

SLOT="0/${PV}"
KEYWORDS="~amd64 ~x86"
LICENSE="BSD-2"
IUSE="doc emacs examples"

# tests reference non-existing directory TEST
RESTRICT="test"

RDEPEND="
	dev-lang/mlton
	doc? (
		virtual/latex-base
		app-text/texi2html
	)
	emacs? (
		virtual/emacs
	)"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${PN}

SITEFILE=50${PN}-gentoo.el

PATCHES=(
	"${FILESDIR}/${PN}-1.7.1-doc-guide-twelf-dot-texi.patch"
	"${FILESDIR}/${PN}-1.7.1-doc-guide-Makefile.patch"
	"${FILESDIR}/${PN}-1.7.1-emacs-twelf.patch"
	"${FILESDIR}/${PN}-1.7.1-emacs-twelf-init.patch"
	"${FILESDIR}/${PN}-1.7.1-Makefile.patch"
	"${FILESDIR}/${PN}-1.7.1-mlton-mlb.patch"
	)

src_prepare() {
	epatch ${PATCHES[@]}
	sed \
		-e "s@/usr/bin@${ROOT}usr/bin@g" \
		-e "s@/usr/share@${ROOT}usr/share@" \
		-i "${S}"/emacs/twelf-init.el \
		|| die "Could not set ROOT in ${S}/emacs/twelf-init.el"
}

src_compile() {
	emake mlton CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS} -fno-PIE"
	if use emacs ; then
		pushd "${S}/emacs" || die "Could change directory to emacs"
		elisp-compile \
			auc-menu.el \
			twelf-font.el \
			twelf-init.el \
			twelf.el \
			|| die "emacs elisp compile failed"
		popd
	fi
	if use doc; then
		pushd doc/guide
		emake all
		popd
	fi
}

ins_example_dir() {
	insinto "/usr/share/${PN}/examples/${1}"
	pushd "${S}/${1}"
	doins -r *
	popd
}

src_install() {
	if use emacs ; then
		elisp-install ${PN} emacs/*.{el,elc}
		cp "${FILESDIR}"/${SITEFILE} "${S}"
		elisp-site-file-install ${SITEFILE}
	fi
	if use examples; then
		ins_example_dir examples
		ins_example_dir examples-clp
		ins_example_dir examples-delphin
	fi
	dobin bin/twelf-server
	dohtml doc/html/index.html
	doinfo doc/guide/twelf.info
	dodoc doc/guide/twelf.dvi doc/guide/twelf.ps doc/guide/twelf.pdf
	dohtml doc/guide/twelf/*
}

pkg_postinst() {
	if use emacs; then
		elisp-site-regen
		ewarn "For twelf emacs, add this line to ~/.emacs"
		ewarn ""
		ewarn '(load (concat twelf-root "/twelf-init.el"))'
	fi
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
