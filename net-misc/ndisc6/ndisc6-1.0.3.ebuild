# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="Recursive DNS Servers discovery Daemon (rdnssd) for IPv6"
HOMEPAGE="https://www.remlab.net/ndisc6/"
SRC_URI="https://www.remlab.net/files/${PN}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 x86 ~x64-macos"
IUSE="debug"

DEPEND="dev-lang/perl
	sys-devel/gettext"
RDEPEND=""

src_configure() {
	econf $(use_enable debug assert)
}

src_install() {
	emake DESTDIR="${D}" install
	newinitd "${FILESDIR}"/rdnssd.rc-1 rdnssd
	newconfd "${FILESDIR}"/rdnssd.conf rdnssd

	exeinto /etc/rdnssd
	newexe "${FILESDIR}"/resolvconf-1 resolvconf
	dodoc AUTHORS ChangeLog NEWS README
}
