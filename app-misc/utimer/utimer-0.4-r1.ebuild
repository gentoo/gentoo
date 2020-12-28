# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A command line timer and stopwatch"
HOMEPAGE="http://utimer.codealpha.net/utimer"
SRC_URI="http://utimer.codealpha.net/dl.php?file=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug nls"

RDEPEND="
	dev-libs/glib:2
	dev-util/intltool"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fno-common.patch
	"${FILESDIR}"/${P}-locale.patch
)
DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable nls)
}
