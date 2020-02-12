# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Video Quirks database for pm-utils"
HOMEPAGE="https://pm-utils.freedesktop.org/"
SRC_URI="https://pm-utils.freedesktop.org/releases/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ia64 ~mips ppc ppc64 s390 sparc x86"
IUSE=""

S="${WORKDIR}"

src_install() {
	insinto /usr/$(get_libdir)/pm-utils
	doins -r video-quirks
}
