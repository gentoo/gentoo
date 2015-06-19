# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-dicts/eblook/eblook-1.6.1.ebuild,v 1.8 2012/10/20 18:32:59 ago Exp $

EAPI=4

DESCRIPTION="Interactive search utility for electronic dictionaries"
HOMEPAGE="http://openlab.ring.gr.jp/edict/eblook/"
SRC_URI="http://openlab.ring.gr.jp/edict/eblook/dist/${P/_/}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE=""

DEPEND=">=dev-libs/eb-3.3.4"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P%_*}"

src_prepare() {
	sed \
		-e 's:LDFAGS:LDFLAGS:g' \
		-i configure || die
}

src_configure() {
	econf --with-eb-conf=/etc/eb.conf
}
