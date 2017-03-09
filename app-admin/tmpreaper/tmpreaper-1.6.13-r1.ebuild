# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils

MY_P="${PN}_${PV}+nmu1"
DESCRIPTION="A utility for removing files based on when they were last accessed"
HOMEPAGE="http://packages.debian.org/sid/tmpreaper"
SRC_URI="mirror://debian/pool/main/t/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND="sys-fs/e2fsprogs"
RDEPEND=""

S=${WORKDIR}/${MY_P/_/-}

PATCHES=(
	"${FILESDIR}"/${P}-fix-protect.patch
	"${FILESDIR}"/${P}-gentoo.patch
)

src_install() {
	emake DESTDIR="${D}" install
	insinto /etc
	doins debian/tmpreaper.conf

	exeinto /etc/cron.daily
	newexe debian/cron.daily tmpreaper
	doman debian/tmpreaper.conf.5
	dodoc README ChangeLog debian/README*
}

pkg_postinst() {
	elog "This package installs a cron script under /etc/cron.daily"
	elog "You can configure it using /etc/tmpreaper.conf"
	elog "Consult tmpreaper.conf man page for more information"
	elog "Read /usr/share/doc/${P}/README.security and"
	elog "remove SHOWWARNING from /etc/tmpreaper.conf afterwards"
}
