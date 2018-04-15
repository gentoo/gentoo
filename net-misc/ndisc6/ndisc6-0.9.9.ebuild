# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Recursive DNS Servers discovery Daemon (rdnssd) for IPv6"
HOMEPAGE="https://www.remlab.net/ndisc6/"
SRC_URI="https://www.remlab.net/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND="dev-lang/perl
	sys-devel/gettext"
RDEPEND=""

src_install() {
	emake DESTDIR="${D}" install || die
	newinitd "${FILESDIR}"/rdnssd.rc rdnssd || die
	newconfd "${FILESDIR}"/rdnssd.conf rdnssd || die
	exeinto /etc/rdnssd
	doexe "${FILESDIR}"/resolvconf || die
	dodoc AUTHORS ChangeLog NEWS README || die
}
