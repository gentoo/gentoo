# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )
inherit python-single-r1

DESCRIPTION="A command-line tool for downloading subs from opensubtitles.org"
HOMEPAGE="https://github.com/akexakex/subdl"
SRC_URI="https://${PN}.googlecode.com/files/${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="${PYTHON_DEPS}"
DEPEND="${RDEPEND}
	app-arch/unzip"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

S=${WORKDIR}

src_prepare() {
	python_fix_shebang ${PN}
}

src_install() {
	dobin ${PN}
	dodoc README.txt
}
