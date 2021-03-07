# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P=nuvoX_${PV}

DESCRIPTION="NuvoX SVG icon theme"
HOMEPAGE="http://www.kde-look.org/content/show.php?content=38467"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
RESTRICT="strip binchecks"

BDEPEND="virtual/imagemagick-tools[png]"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${PN}-07.1-fix-buildset.patch )

src_compile() {
	./buildset || die
}

src_install() {
	dodoc nuvoX_0.7/readme.txt
	rm nuvoX_0.7/{readme,license}.txt || die

	insinto /usr/share/icons/${PN}
	doins -r nuvoX_0.7/.
}
