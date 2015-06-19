# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/cgisysinfo/cgisysinfo-0.4.1.ebuild,v 1.2 2014/08/10 20:12:53 slyfox Exp $

EAPI="5"

if [[ ${PV} = *9999* ]]; then
	WANT_AUTOCONF="2.5"
	WANT_AUTOMAKE="1.10"
	inherit autotools mercurial
	EHG_REPO_URI="http://hg.rafaelmartins.eng.br/cgisysinfo/"
	KEYWORDS=""
else
	SRC_URI="http://distfiles.rafaelmartins.eng.br/${PN}/${P}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="A small cgi utility to show basic system information"
HOMEPAGE="http://projects.rafaelmartins.eng.br/cgisysinfo"

LICENSE="GPL-2"
SLOT="0"
IUSE="fastcgi"

DEPEND="fastcgi? ( dev-libs/fcgi )"
RDEPEND="${DEPEND}"

DOCS="README AUTHORS NEWS"

src_prepare() {
	[[ ${PV} = *9999* ]] && eautoreconf
}

src_configure() {
	econf $(use_enable fastcgi)
}
