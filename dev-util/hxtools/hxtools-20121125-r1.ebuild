# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="A collection of tools and scripts"
HOMEPAGE="http://inai.de/projects/hxtools/"
SRC_URI="http://jftp.inai.de/${PN}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

RDEPEND="
	dev-lang/perl
	sys-libs/libcap
	>=sys-libs/libhx-3.12.1
	sys-apps/pciutils
"
DEPEND="${RDEPEND}"

src_install() {
	default

	# man2html is provided by man
	rm -rf "${ED}"/usr/bin/man2html
	rm -rf "${ED}"/usr/share/man/man1/man2html*
}
