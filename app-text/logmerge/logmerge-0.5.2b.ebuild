# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Small and powerful script to merge two or more logfiles"
HOMEPAGE="https://github.com/ildar-shaimordanov/logmerge"
SRC_URI="https://github.com/ildar-shaimordanov/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-lang/perl"

src_install() {
	default
	dobin ${PN}
}
