# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_P="${PN}-${PV%.*}-${PV/*.}"

DESCRIPTION="IPA dictionary for MeCab"
HOMEPAGE="http://taku910.github.io/mecab/"
SRC_URI="mirror://sourceforge/${PN%-*}/${MY_P}.tar.gz"

LICENSE="ipadic"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ia64 ppc ppc64 s390 sparc x86"
IUSE="unicode"

DEPEND="app-text/mecab[unicode=]"
S="${WORKDIR}/${MY_P}"

src_configure() {
	econf $(use_with unicode charset UTF-8)
}
