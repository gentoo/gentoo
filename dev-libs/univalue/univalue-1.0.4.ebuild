# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="C++ universal value object and JSON library"
HOMEPAGE="https://github.com/jgarzik/univalue"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/jgarzik/${PN}.git"
	inherit git-r3
else
	SRC_URI="https://codeload.github.com/jgarzik/${PN}/tar.gz/v${PV} -> ${P}.tar.gz"
	KEYWORDS="amd64 arm ~arm64 ~mips ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
fi

LICENSE="MIT"
SLOT="0/0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
