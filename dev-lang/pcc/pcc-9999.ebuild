# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils versionator autotools

DESCRIPTION="pcc portable c compiler"
HOMEPAGE="http://pcc.ludd.ltu.se"

if [[ ${PV} = 9999 ]]; then
	inherit cvs
	ECVS_SERVER="pcc.ludd.ltu.se:/cvsroot"
	ECVS_MODULE="${PN}"
	KEYWORDS=""
	S="${WORKDIR}/${PN}"
else
	SRC_URI="ftp://pcc.ludd.ltu.se/pub/pcc-releases/${P}.tgz"
	KEYWORDS="~x86 ~amd64 ~amd64-fbsd"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""
DEPEND=">=dev-libs/pcc-libs-${PV}"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i -e 's/AC_CHECK_PROG(strip,strip,yes,no)//' configure.ac || die "Failed to fix configure.ac"
	sed -i -e 's/AC_SUBST(strip)//' configure.ac || die "Failed to fix configure.ac more"
	eautoreconf
}

src_configure() {
	econf --disable-stripping
}

src_compile() {
	emake  || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
