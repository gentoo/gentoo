# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils elisp-common

DESCRIPTION="language for scientific graphics programming"
HOMEPAGE="http://gri.sourceforge.net/"
SRC_URI="mirror://sourceforge/gri/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc emacs examples"
RESTRICT="test"

DEPEND=">=sci-libs/netcdf-3.5.0
	virtual/latex-base
	media-gfx/imagemagick[png]
	app-text/ghostscript-gpl
	emacs? ( virtual/emacs )"

RDEPEND="${DEPEND}"

SITEFILE="50gri-gentoo.el"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-2.12.18-postscript.patch
}

src_compile() {
	VARTEXFONTS="${T}/fonts" emake || die
	if use emacs; then
		elisp-compile src/*.el || die
	fi
}

src_install() {
	# Replace PREFIX now and correct paths in the startup message.
	sed -e s,PREFIX/share/gri/doc/,/usr/share/doc/${P}/, -i "${S}/src/startup.msg"

	einstall || die

	# license text not necessary
	rm "${D}"/usr/share/gri/doc/license.txt

	# install target installs it always and in the wrong location
	# remove it here and call elisp-install in case of USE=emacs below
	rm -rf "${D}"/usr/share/emacs

	if ! use doc; then
		sed -e "s/Manual at.*//" -i "${D}"/usr/share/gri/startup.msg
		rm "${D}"/usr/share/gri/doc/cmdrefcard.ps
		rm "${D}"/usr/share/gri/doc/refcard.ps
		rm -rf "${D}"/usr/share/gri/doc/html
	fi
	if ! use examples; then
		sed -e "s/Examples at.*//" -i "${D}"/usr/share/gri/startup.msg
		rm -rf "${D}"/usr/share/gri/doc/examples
	fi

	dodoc README

	#move docs to the proper place
	mv "${D}"/usr/share/gri/doc/* "${D}/usr/share/doc/${PF}"
	rmdir "${D}/usr/share/gri/doc/"

	if use emacs; then
		cd src
		elisp-install ${PN} *.{el,elc} || die
		elisp-site-file-install "${FILESDIR}/${SITEFILE}" \
			|| die
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
