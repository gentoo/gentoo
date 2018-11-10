# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit cmake-utils

DESCRIPTION="A command-line markdown to fb2 convertor"
HOMEPAGE="http://cdslow.org.ru/fictionup/"
SRC_URI="http://cdslow.org.ru/files/${PN}/${P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"
IUSE=""
KEYWORDS="~amd64 ~x86"
DEPEND="dev-libs/libyaml"
RDEPEND="${DEPEND}"

src_install() {
	cmake-utils_src_install
	mv "${D}"usr/share/doc/${PN} "${D}"usr/share/doc/${PF} || die "doc mv failed"
}
