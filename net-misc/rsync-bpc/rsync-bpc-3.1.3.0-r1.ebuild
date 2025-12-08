# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Rsync-bpc is a customized version of rsync that is used as part of BackupPC"
HOMEPAGE="https://github.com/backuppc/rsync-bpc"
SRC_URI="https://github.com/backuppc/rsync-bpc/releases/download/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="virtual/ssh"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-3.1.3.0-r1-fix-gettimeofday-error.patch" #874666
)

src_prepare() {
	default
	eautoreconf
}
