# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Tool for creating backups of MySQL server's data files using LVM snapshots"
HOMEPAGE="http://lenzg.net/mylvmbackup/"
SRC_URI="http://lenzg.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND=""
RDEPEND="
	dev-perl/Config-IniFiles
	dev-perl/DBD-mysql
	dev-perl/TimeDate
	>=sys-fs/lvm2-2.02.06
	virtual/mysql"

PATCHES=(
	"${FILESDIR}"/${PN}-0.14-fix-build-system.patch
	"${FILESDIR}"/${PN}-0.14-fix-config.patch
)

src_install() {
	default

	keepdir /var/tmp/${PN}/{backup,mnt}
	fperms 0700 /var/tmp/${PN}/
}
