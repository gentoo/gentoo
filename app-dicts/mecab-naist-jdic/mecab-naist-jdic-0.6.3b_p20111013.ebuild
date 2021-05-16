# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_P="${P/_p/-}"

DESCRIPTION="NAIST Japanese Dictionary"
HOMEPAGE="http://sourceforge.jp/projects/naist-jdic/"
SRC_URI="mirror://sourceforge.jp/${PN#*-}/53500/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="unicode"

DEPEND="app-text/mecab[unicode=]"
S="${WORKDIR}/${MY_P}"

src_configure() {
	econf $(use_with unicode charset UTF-8)
}
