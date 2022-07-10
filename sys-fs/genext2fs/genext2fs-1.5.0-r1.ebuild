# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="generate ext2 file systems"
HOMEPAGE="https://github.com/bestouff/genext2fs"
SRC_URI="https://github.com/bestouff/genext2fs/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86"

PATCHES=( "${FILESDIR}/backport-pr-32.patch" )

src_prepare() {
	default
	eautoreconf
}
