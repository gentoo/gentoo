# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

DESCRIPTION="Rules for Sagan log analyzer"
HOMEPAGE="http://sagan.softwink.com/"
SRC_URI="http://sagan.quadrantsec.com/rules/sagan-rules-06172014.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+lognorm"

DEPEND=""
RDEPEND="${DEPEND}"
PDEPEND="app-admin/sagan"

S=${WORKDIR}/rules

src_install() {
	insinto /etc/sagan-rules
	doins ./*.config
	doins ./*rules
	doins ./*map
	if use lognorm ; then
		doins ./*normalize.rulebase
	fi
}
