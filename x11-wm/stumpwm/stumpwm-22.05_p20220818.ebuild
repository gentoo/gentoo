# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit common-lisp-3 autotools desktop elisp-common optfeature xdg-utils

MY_COMMIT="740e945d742d85aef36e0ed9467de9bbbf5eafd2"

DESCRIPTION="A Window Manager written entirely in Common Lisp"
HOMEPAGE="https://stumpwm.github.io/"
SRC_URI="https://github.com/stumpwm/stumpwm/archive/${MY_COMMIT}.tar.gz -> ${PN}-${MY_COMMIT}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc emacs"

S="${WORKDIR}/${PN}-${MY_COMMIT}"

RESTRICT="strip"

RDEPEND="dev-lisp/alexandria
		dev-lisp/cl-ppcre
		dev-lisp/clx
		>=dev-lisp/sbcl-1.3.0
		emacs? ( >=app-editors/emacs-23.1:* )"
DEPEND="${RDEPEND}"
BDEPEND="sys-apps/texinfo
		doc? ( virtual/texi2dvi )"

SITEFILE=70${PN}-gentoo.el
CLPKGDIR="${CLSOURCEROOT}/${CLPACKAGE}"

install_docs() {
	local pdffile="${PN}.pdf"

	texi2pdf -o "${pdffile}" "${PN}.texi.in" && dodoc "${pdffile}" || die
	cp "${FILESDIR}/README.Gentoo" . && sed -i "s:@VERSION@:${PV}:" README.Gentoo || die
	dodoc AUTHORS NEWS README.md README.Gentoo
	doinfo "${PN}.info"
	docinto examples
	dodoc sample-stumpwmrc.lisp
}

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	xdg_environment_reset
	econf --with-lisp=sbcl
}

src_compile() {
	emake -j1
}

src_install() {
	dobin stumpwm
	make_session_desktop StumpWM /usr/bin/stumpwm

	common-lisp-install-sources *.lisp
	common-lisp-install-asdf
	# Fix ASDF dir
	sed -i -e "/(:directory/c\   (:directory \"${CLPKGDIR}\")" \
		"${D}${CLPKGDIR}/load-stumpwm.lisp" || die
	use doc && install_docs
}

pkg_postinst() {
	use emacs && elisp-site-regen
	optfeature "extension modules" x11-wm/stumpwm-contrib
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
