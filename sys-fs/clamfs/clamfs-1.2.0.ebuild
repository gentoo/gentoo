# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools linux-info

DESCRIPTION="A FUSE-based user-space file system with on-access anti-virus file scanning"
HOMEPAGE="https://github.com/burghardt/clamfs"
SRC_URI="https://github.com/burghardt/clamfs/releases/download/${P}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=">=dev-libs/boost-1.33
	dev-libs/poco
	dev-libs/rlog
	sys-fs/fuse:3"
RDEPEND="${DEPEND}
	app-antivirus/clamav"

CONFIG_CHECK="~FUSE_FS"

src_prepare() {
	default
	eautoreconf
}

src_install() {
	default

	insinto /etc/clamfs
	doins doc/clamfs.xml

	newinitd "${FILESDIR}/${PN}.initd" ${PN}
	newconfd "${FILESDIR}/${PN}.confd" ${PN}

	dodoc AUTHORS ChangeLog NEWS README TODO
}
