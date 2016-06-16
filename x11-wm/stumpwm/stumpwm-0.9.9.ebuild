# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools common-lisp-3 eutils elisp-common xdg-utils

DESCRIPTION="Stumpwm is a Window Manager written entirely in Common Lisp."
HOMEPAGE="https://stumpwm.github.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="contrib doc emacs clisp ecl +sbcl"

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
CLPKGDIR="${CLSOURCEROOT}/${CLPACKAGE}"
CONTRIBDIR="${CLPKGDIR}/contrib"

get_lisp() {
	local lisp

	for lisp in "$@" ; do
		use ${lisp} && echo ${lisp} && return
	done
}

do_doc() {
	local pdffile="${PN}.pdf"

	texi2pdf -o "${pdffile}" "${PN}.texi" && dodoc "${pdffile}" || die
	cp "${FILESDIR}/README.Gentoo" . && sed -i "s:@VERSION@:${PV}:" README.Gentoo || die
	dodoc AUTHORS NEWS README.md README.Gentoo
	doinfo "${PN}.info"
	docinto examples ; dodoc sample-stumpwmrc.lisp
}

do_contrib() {
	emake install-modules
	rm -r "${D}${CONTRIBDIR}"/.git* || die
}

src_prepare() {
	# Upstream didn't change the version before packaging
	sed -i -e 's/:version "0.9.8"/:version "0.9.9"/' "${PN}.asd" || die
	# Bug 534592. Does not build with asdf:oos, using require to load the package
	sed -i "load-${PN}.lisp.in" -e "s/asdf:oos 'asdf:load-op/require/" || die
	if use contrib ; then
		# Fix contrib directory
		sed -i -e "s|@CONTRIB_DIR@|@MODULE_DIR@|" make-image.lisp.in || die
		sed -i -e "s|\~\/.${CLPACKAGE}\.d/modules|${D}${CONTRIBDIR}|" Makefile.in || die
		sed -i -e "s|\${HOME}/\.${CLPACKAGE}\.d/modules|${CONTRIBDIR}|" configure.ac || die
	fi
	eautoreconf
}

src_configure() {
	local moduleconfig

	xdg_environment_reset
	use contrib && moduleconfig="--with-module-dir=${CONTRIBDIR}/contrib"
	econf --with-lisp=$(get_lisp sbcl clisp ecl) "${moduleconfig}"
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
	# Fix ASDF dir
	sed -i -e "/(:directory/c\   (:directory \"${CLPKGDIR}\")" \
		"${D}${CLPKGDIR}/load-stumpwm.lisp" || die
	use doc && do_doc
	use contrib && do_contrib
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
