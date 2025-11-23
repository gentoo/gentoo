# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${PN}-${PV%.*}-${PV/*.}"

DESCRIPTION="IPA dictionary for MeCab"
HOMEPAGE="https://taku910.github.io/mecab/"
SRC_URI="https://downloads.sourceforge.net/${PN%-*}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="ipadic"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~loong ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="unicode"

DEPEND="app-text/mecab[unicode=]"

src_configure() {
	econf $(use_with unicode charset UTF-8)
}
