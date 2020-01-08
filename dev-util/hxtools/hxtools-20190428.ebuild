# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A collection of tools and scripts"
HOMEPAGE="http://inai.de/projects/hxtools/"
SRC_URI="http://jftp.inai.de/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	>=sys-apps/pciutils-3
	>=sys-apps/util-linux-2.19
	>=sys-libs/libhx-3.12.1
	dev-lang/perl
	sys-libs/libcap
	x11-libs/libxcb:0=
"
DEPEND="${RDEPEND}"

src_install() {
	default

	# man2html is provided by man
	rm -r "${ED}"/usr/bin/man2html || die 
	rm -r "${ED}"/usr/share/man/man1/man2html* || die

	# Don't collide with dev-util/cwdiff
	mv "${ED}"/usr/bin/cwdiff "${ED}"/usr/bin/cwdiff.hx || die
	mv "${ED}"/usr/share/man/man1/cwdiff.1 "${ED}"/usr/share/man/man1/cwdiff.hx.1 || die

	# Gentoo doesn't have /usr/share/kbd:
	mv "${ED}"/usr/share/kbd/* "${ED}"/usr/share/ || die
	gzip "${ED}"/usr/share/consolefonts/*fnt || die
}
