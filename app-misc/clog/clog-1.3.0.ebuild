# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="clog is a colorized log tail utility"
HOMEPAGE="http://tasktools.org/projects/clog/"
SRC_URI="http://tasktools.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_prepare() {
	default
	# use the correct directory locations
	sed -i -e "s:/usr/local/share/doc/clog/rc:${EPREFIX}/usr/share/clog/rc:" \
		doc/man/clog.1.in || die
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DTASK_DOCDIR="${EPREFIX}"/usr/share/doc/${PF}
	)
	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
