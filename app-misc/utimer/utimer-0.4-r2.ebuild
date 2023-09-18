# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A command line timer and stopwatch"
HOMEPAGE="https://sourceforge.net/projects/utimer/"
SRC_URI="http://utimer.codealpha.net/dl.php?file=${P}.tar.gz -> ${P}.tar.gz"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug nls"
RESTRICT="test" #630952

RDEPEND="
	dev-libs/glib:2
	dev-util/intltool"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-locale.patch
	"${FILESDIR}"/${P}-fix-build-for-clang16.patch
)
DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable nls)
}
