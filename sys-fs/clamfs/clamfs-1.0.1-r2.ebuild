# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"
inherit eutils linux-info

DESCRIPTION="A FUSE-based user-space file system with on-access anti-virus file scanning"
HOMEPAGE="http://clamfs.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-libs/boost-1.33
	sys-fs/fuse
	dev-cpp/commoncpp2
	dev-libs/rlog
	dev-libs/poco"
RDEPEND="${DEPEND}
	app-antivirus/clamav"

CONFIG_CHECK="~FUSE_FS"

src_prepare() {
	eapply "${FILESDIR}/${P}-gentoo.patch"
	eapply -p0 "${FILESDIR}/${P}-gcc45.patch"
	eapply_user
}

src_install() {
	emake install DESTDIR="${D}"

	insinto /etc/clamfs
	doins doc/clamfs.xml

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	dodoc AUTHORS ChangeLog NEWS README TODO
}
