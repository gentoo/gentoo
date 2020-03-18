# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="Tools for logs with ANSI color"
HOMEPAGE="https://github.com/kilobyte/colorized-logs/"
SRC_URI="https://github.com/kilobyte/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install
	# Rename to not collide with dev-python/ansi2html
	mv "${ED}/usr/bin/ansi2html" "${ED}/usr/bin/cl-ansi2html" || die
	mv "${ED}/usr/share/man/man1/ansi2html.1" "${ED}/usr/share/man/man1/cl-ansi2html.1" || die
}
