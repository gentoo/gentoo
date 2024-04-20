# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit tmpfiles

DESCRIPTION="Tool for creating backups of MySQL server's data files using LVM snapshots"
HOMEPAGE="https://lenzg.net/mylvmbackup/"
SRC_URI="https://lenzg.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	dev-perl/Config-IniFiles
	dev-perl/DBD-mysql
	dev-perl/File-Copy-Recursive
	dev-perl/TimeDate
	sys-fs/lvm2
	virtual/mysql
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.16-fix-build-system.patch
	"${FILESDIR}"/${PN}-0.14-fix-config.patch
)

src_install() {
	default

	dotmpfiles "${FILESDIR}/${PN}.conf"
}

pkg_postinst() {
	tmpfiles_process "${PN}.conf"
}
