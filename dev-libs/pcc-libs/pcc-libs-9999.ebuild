# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/pcc-libs/pcc-libs-9999.ebuild,v 1.1 2015/05/13 03:06:19 patrick Exp $

EAPI=5

inherit eutils versionator

DESCRIPTION="pcc compiler support libs"
HOMEPAGE="http://pcc.ludd.ltu.se"

if [[ ${PV} = 9999 ]]; then
	inherit cvs
	ECVS_SERVER="pcc.ludd.ltu.se:/cvsroot"
	ECVS_MODULE="${PN}"
	S="${WORKDIR}/${PN}"
	KEYWORDS=""
else
	SRC_URI="ftp://pcc.ludd.ltu.se/pub/pcc-releases/${P}.tgz"
	KEYWORDS="~x86 ~amd64 ~amd64-fbsd"
fi
LICENSE="BSD"
SLOT="0"

IUSE=""
DEPEND=""
RDEPEND="${DEPEND}"

src_compile() {
	# not parallel-safe yet
	emake -j1 || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
