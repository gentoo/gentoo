# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-functions

DESCRIPTION="A utility to make consistent snapshots of running OpenVZ containers"
HOMEPAGE="http://pve.proxmox.com/wiki/VZDump"
SRC_URI="http://www.proxmox.com/cms_proxmox/cms/upload/vzdump/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-lang/perl:="
RDEPEND="${DEPEND}
	app-misc/cstream
	dev-perl/LockFile-Simple
	net-misc/rsync
	sys-cluster/vzctl
	sys-fs/lvm2
	virtual/mta
	virtual/perl-Getopt-Long"

src_compile() {
	return
}

src_install() {
	emake PERLLIBDIR="$(perl_get_vendorlib)/PVE" DESTDIR="${D}" install
	einstalldocs
}
