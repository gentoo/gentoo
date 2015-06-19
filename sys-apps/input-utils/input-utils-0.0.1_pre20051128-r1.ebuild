# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/sys-apps/input-utils/input-utils-0.0.1_pre20051128-r1.ebuild,v 1.4 2008/01/20 18:47:24 angelos Exp $

inherit eutils

MY_P="input-${PV/0.0.1_pre/}-143821"
DEBIAN_PR=4
DEBIAN_P="${PN}_${PV/1_pre/}-${DEBIAN_PR}.diff.gz"

DESCRIPTION="Small collection of linux input layer utils"
HOMEPAGE="http://dl.bytesex.org/cvs-snapshots/"
SRC_URI="http://dl.bytesex.org/cvs-snapshots/${MY_P}.tar.gz
		mirror://debian/pool/main/i/input-utils/${DEBIAN_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/input"

src_unpack() {
	unpack ${MY_P}.tar.gz
	EPATCH_OPTS="-d ${S} -p1 " epatch "${DISTDIR}"/${DEBIAN_P}
	for p in $(<"${S}"/debian/patches/series) ; do
		EPATCH_OPTS="-d ${S} -p1 " epatch "${S}"/debian/patches/${p}
	done
	sed -i -e '/INSTALL_BINARY/s,-s,,g' "${S}"/mk/Variables.mk \
		|| die "Failed to sed"
}

src_install() {
	make install bindir="${D}"/usr/bin mandir="${D}"/usr/share/man || die "make install failed"
	dodoc lircd.conf
	dodoc README
}
