# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit common-lisp-3 eutils elisp-common autotools

DESCRIPTION="Stumpwm is a tiling, keyboard driven X11 Window Manager written entirely in Common Lisp."
HOMEPAGE="http://www.nongnu.org/stumpwm/"
SRC_URI="http://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc emacs clisp ecl +sbcl"

RESTRICT="strip mirror"

RDEPEND="dev-lisp/cl-ppcre
		sbcl?  ( >=dev-lisp/sbcl-1.0.32 )
		sbcl? ( >=dev-lisp/clx-0.7.4 )
		!sbcl? ( !clisp? ( !ecl? ( >=dev-lisp/sbcl-1.0.32 ) ) )
		!sbcl? ( !clisp? (  ecl? ( >=dev-lisp/ecls-10.4.1 ) ) )
		!sbcl? (  clisp? ( >=dev-lisp/clisp-2.44[X,new-clx] ) )
		emacs? ( virtual/emacs app-emacs/slime )"
DEPEND="${RDEPEND}
		sys-apps/texinfo
		doc? ( virtual/texi2dvi )"

SITEFILE=70${PN}-gentoo.el

get_lisp() {
	local lisp

	for lisp in "$@" ; do
		use ${lisp} && echo ${lisp} && return
	done
}

do_doc() {
	local pdffile="${PN}.pdf"

	texi2pdf -o "${pdffile}" "${PN}.texi.in" && dodoc "${pdffile}" || die
	cp "${FILESDIR}/README.Gentoo" . && sed -i "s:@VERSION@:${PV}:" README.Gentoo || die
	dodoc AUTHORS NEWS README.md README.Gentoo
	doinfo "${PN}.info"
	docinto examples ; dodoc sample-stumpwmrc.lisp
}

src_prepare() {
	# Upstream didn't change the version before packaging
	sed -i "${S}/${PN}.asd" -e 's/:version "0.9.8"/:version "0.9.9"/' || die
	# Bug 534592. Does not build with asdf:oos, using require to load the package
	sed -i "${S}/load-${PN}.lisp.in" -e "s/asdf:oos 'asdf:load-op/require/" || die
	eautoreconf
}

src_configure() {
	econf --with-lisp=$(get_lisp sbcl clisp ecl)
}

src_compile() {
	emake -j1
}

src_install() {
	common-lisp-export-impl-args $(get_lisp sbcl clisp ecl)
	dobin stumpwm
	make_session_desktop StumpWM /usr/bin/stumpwm

	common-lisp-install-sources *.lisp
	common-lisp-install-asdf ${PN}.asd
	use doc && do_doc
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
