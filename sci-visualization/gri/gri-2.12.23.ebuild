# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils elisp-common

DESCRIPTION="Language for scientific graphics programming"
HOMEPAGE="http://gri.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux"
IUSE="doc emacs examples hdf5"

DEPEND="
	>=sci-libs/netcdf-4
	virtual/latex-base
	|| ( media-gfx/imagemagick[png] media-gfx/graphicsmagick[png,imagemagick] )
	app-text/ghostscript-gpl
	emacs? ( virtual/emacs )"
RDEPEND="${DEPEND}"

SITEFILE="50gri-gentoo.el"

src_prepare() {
	epatch \
		"${FILESDIR}"/${PN}-2.12.18-postscript.patch \
		"${FILESDIR}"/${P}-perl-5.16.patch \
		"${FILESDIR}"/${P}-texinfo5.patch
	# Makefile.am contains a call to the missing script that triggers gentoo qa
	sed -i -e 's|${SHELL} ../missing --run tex|tex|g' \
		doc/Makefile.in || die
	sed \
		-e "/system/d" \
		-i doc/tst_suite/tst_rpn.gri || die
}

src_compile() {
	# gentoo bug #302621
	use hdf5 && has_version sci-libs/hdf5[mpi] && \
		export CXX=mpicxx CC=mpicc
	VARTEXFONTS="${T}/fonts" emake
	use emacs && elisp-compile src/*.el
}

src_install() {
	default
	# license text not necessary
	rm "${ED}"/usr/share/gri/doc/license.txt || die

	# install target installs it always and in the wrong location
	# remove it here and call elisp-install in case of USE=emacs below
	rm -rf "${ED}"/usr/share/emacs || die

	if ! use doc; then
		sed -i -e "s/Manual at.*//" "${ED}"/usr/share/gri/startup.msg || die
		rm "${ED}"/usr/share/gri/doc/{cmd,}refcard.ps || die
		rm -rf "${ED}"/usr/share/gri/doc/html || die
	fi
	if ! use examples; then
		sed -i -e "s/Examples at.*//" "${ED}"/usr/share/gri/startup.msg || die
		rm -rf "${ED}"/usr/share/gri/doc/examples || die
	fi
	#move docs to the proper place
	use doc || use examples && \
		mv -f "${ED}"/usr/share/gri/doc/* "${ED}"/usr/share/doc/${PF}
	rm -rf "${ED}"/usr/share/gri/doc || die

	if use emacs; then
		cd src
		elisp-install ${PN} *.{el,elc}
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
