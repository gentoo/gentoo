# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

DESCRIPTION="A utility to make consistent snapshots of running OpenVZ containers"
HOMEPAGE="http://pve.proxmox.com/wiki/VZDump"
SRC_URI="http://www.proxmox.com/cms_proxmox/cms/upload/vzdump/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

RDEPEND="dev-lang/perl
	dev-perl/LockFile-Simple
	virtual/perl-Getopt-Long
	sys-cluster/vzctl
	net-misc/rsync
	app-misc/cstream
	virtual/mta
	sys-fs/lvm2"

src_compile() {
	:;
}

src_install() {
	local installvendorlib
	eval "$(perl -V:installvendorlib )"
	make PERLLIBDIR="${installvendorlib}/PVE" DESTDIR="${D}" install || die "make install failed"
	dodoc ChangeLog TODO
}
