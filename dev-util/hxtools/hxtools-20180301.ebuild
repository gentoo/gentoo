# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A collection of tools and scripts"
HOMEPAGE="http://inai.de/projects/hxtools/"
SRC_URI="http://jftp.inai.de/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-lang/perl
	>=sys-apps/util-linux-2.19
	sys-libs/libcap
	>=sys-libs/libhx-3.12.1
	>=sys-apps/pciutils-3
	x11-libs/libxcb:0=
"
DEPEND="${RDEPEND}"

src_install() {
	default

	# man2html is provided by man
	rm -rf "${ED}"/usr/bin/man2html
	rm -rf "${ED}"/usr/share/man/man1/man2html*

	# Don't collide with dev-util/cwdiff
	mv "${ED}"/usr/bin/cwdiff "${ED}"/usr/bin/cwdiff.hx || die
	mv "${ED}"/usr/share/man/man1/cwdiff.1 "${ED}"/usr/share/man/man1/cwdiff.hx.1 || die
}
