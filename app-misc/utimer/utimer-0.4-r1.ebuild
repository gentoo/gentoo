# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A command line timer and stopwatch"
HOMEPAGE="http://utimer.codealpha.net/utimer"
SRC_URI="http://utimer.codealpha.net/dl.php?file=${P}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug nls"

DEPEND="
	dev-libs/glib:2
	dev-util/intltool"

RDEPEND="${RDEPEND}"

DOCS=( AUTHORS ChangeLog NEWS README )

src_configure() {
	local myconf=( --enable-debug=no )
	use debug || myconf=( --enable-debug=yes )
	econf "${myconf[@]}" $(use_enable nls)
}

src_install() {
	emake install DESTDIR="${D}"
	einstalldocs
}
