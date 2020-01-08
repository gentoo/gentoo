# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Library of unicode annotation data"
HOMEPAGE="http://libuninameslist.sourceforge.net/"
SRC_URI="mirror://sourceforge/libuninameslist/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"
IUSE=""

S="${WORKDIR}/${PN}"

src_configure() {
	econf \
		--disable-static
}

src_install() {
	default
	find "${ED%/}"/usr -name '*.la' -delete || die
}
