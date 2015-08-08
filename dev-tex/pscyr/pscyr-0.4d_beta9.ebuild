# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit latex-package

DESCRIPTION="Type1 cyrillic fonts collection"
HOMEPAGE="ftp://scon155.phys.msu.su/pub/russian/psfonts/"
SRC_URI="ftp://scon155.phys.msu.su/pub/russian/psfonts/0.4d-beta/PSCyr-0.4-beta9-tex.tar.gz
		ftp://scon155.phys.msu.su/pub/russian/psfonts/0.4d-beta/PSCyr-0.4-beta9-type1.tar.gz"
LICENSE="LPPL-1.2"

SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"

SUPPLIER="public"

S="${WORKDIR}/PSCyr"

src_install() {

	for each in dvips/pscyr tex/latex/pscyr fonts/tfm/public/pscyr \
		fonts/vf/public/pscyr fonts/type1/public/pscyr fonts/afm/public/pscyr; do
		cd "${S}"
		cd "$each"
		latex-package_src_install
	done
	cd "${S}"
	insinto "${TEXMF}/fonts/map/dvips/pscyr"
	doins dvips/pscyr/pscyr.map || die "doins $i failed"

	for each in dvips/pscyr/*.enc; do
		insinto "${TEXMF}/fonts/enc/dvips/pscyr"
		doins "$each" || die "doins $i failed"
	done

	insinto /etc/texmf/updmap.d
	doins "${FILESDIR}/90pscyr.cfg"

	dodoc doc/README.* doc/PROBLEMS ChangeLog
}
