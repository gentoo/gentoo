# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-misc/vmnet/vmnet-0.4.ebuild,v 1.10 2010/10/28 09:39:53 ssuominen Exp $

inherit eutils flag-o-matic

DESCRIPTION="A simple virtual networking program - SLIP over stdin/out"
HOMEPAGE="ftp://ftp.xos.nl/pub/linux/vmnet/"
# The main site is often down
# So this might be better but it's a different filename
# http://ftp.debian.org/debian/pool/main/${PN:0:1}/${PN}/${P/-/_}.orig.tar.gz
# We use the debian patch anyway
SRC_URI="ftp://ftp.xos.nl/pub/linux/${PN}/${P}.tar.gz
		mirror://debian/pool/main/${PN:0:1}/${PN}/${P/-/_}-1.diff.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

DEPEND="sys-apps/net-tools"

src_unpack() {
	unpack ${P}.tar.gz
	epatch "${DISTDIR}"/${P/-/_}-1.diff.gz
}

src_compile() {
	append-ldflags -Wl,-z,now
	emake || die "Emake failed"
}

src_install() {
	dobin ${PN} || die "dobin"
	fperms 4711 /usr/bin/${PN} || die "fperms"

	doman ${PN}.1
	dodoc README debian/${PN}.sgml

	insinto /etc
	doins debian/${PN}.conf
}

pkg_postinst() {
	einfo "Don't forgot to ensure SLIP support is in your kernel!"
}
