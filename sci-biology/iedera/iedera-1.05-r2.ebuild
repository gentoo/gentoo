# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="A subset seed design tool for DNA sequence alignment"
HOMEPAGE="http://bioinfo.lifl.fr/yass/iedera.php"
SRC_URI="http://bioinfo.lifl.fr/yass/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

PATCHES=( "${FILESDIR}"/${P}-fix-buildsystem.patch )

src_prepare() {
	default
	eautoreconf
}
