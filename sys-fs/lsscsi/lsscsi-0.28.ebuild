# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils

DESCRIPTION="SCSI sysfs query tool"
HOMEPAGE="http://sg.danny.cz/scsi/lsscsi.html"
SRC_URI="http://sg.danny.cz/scsi/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sparc x86"

src_prepare() {
	epatch "${FILESDIR}"/${P}-sysmacros.patch #580494
}
