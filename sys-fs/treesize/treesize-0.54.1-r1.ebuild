# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A disk consumption analyzing tool"
HOMEPAGE="http://treesize.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.tbz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="x11-libs/gtk+:2"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PV}-amd64.patch
	"${FILESDIR}"/${PV}-fno-common.patch
)

src_prepare() {
	default

	# Bogus shipped symlinks to a fixed version of automake
	# bug #760498
	rm config.{guess,sub} || die

	eautoreconf
}
