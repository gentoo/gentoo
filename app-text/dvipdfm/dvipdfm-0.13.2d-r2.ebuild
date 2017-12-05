# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=3
inherit eutils

DESCRIPTION="DVI to PDF translator"
HOMEPAGE="https://ctan.org/pkg/dvipdfm"
SRC_URI="http://mirrors.ctan.org/dviware/dvipdfm/${P}.tar.gz"

#the source has a GPL-2 COPYING file, CTAN lists as LPPL by mistake
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND="!>=app-text/tetex-2
	>=media-libs/libpng-1.2.1
	>=sys-libs/zlib-1.1.4
	!app-text/ptex
	virtual/latex-base"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}

src_prepare() {
	epatch "${FILESDIR}"/${P}-libpng14.patch
}

src_install () {
	einstall texmf="${ED}usr/share/texmf-site" || die "einstall failed!"

	# Install .map and .enc files to correct locations, bug #200956
	dodir /usr/share/texmf-site/fonts/map/dvipdfm/base
	local i
	for i in cmr.map psbase14.map lw35urw.map lw35urwa.map t1fonts.map; do
		mv "${ED}usr/share/texmf-site/dvipdfm/config/${i}" "${ED}usr/share/texmf-site/fonts/map/dvipdfm/base" || die "moving .map file failed"
	done

	dodir /usr/share/texmf-site/fonts/enc/dvipdfm

	mv "${ED}usr/share/texmf-site/dvipdfm/base" "${ED}usr/share/texmf-site/fonts/enc/dvipdfm/base" || die "moving .enc file failed"

	dodoc AUTHORS ChangeLog Credits NEWS OBTAINING README* TODO

	docinto doc
	dodoc doc/*

	docinto latex-support
	dodoc latex-support/*

	insinto /usr/share/texmf-site/tex/latex/dvipdfm/
	doins latex-support/dvipdfm.def
}

pkg_postinst() {
	if [ "$ROOT" = "/" ] ; then
		"${EPREFIX}"/usr/sbin/texmf-update
	fi
}
