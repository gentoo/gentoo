# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_PN=CQRlib
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Utility library for quaternion arithmetic / rotation math (ANSI C implemented)"
HOMEPAGE="http://cqrlib.sourceforge.net/"
SRC_URI="https://github.com/yayahjb/${PN}/archive/${MY_P}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="dev-libs/cvector"
DEPEND="${RDEPEND}"

DOCS=( README_CQRlib.txt )
HTML_DOCS=( README_CQRlib.html )

S="${WORKDIR}"/${PN}-${MY_P}

PATCHES=(
	"${FILESDIR}/${PV}-libtool.patch" # 778911
	"${FILESDIR}/${PV}-build.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_compile() {
	emake all
}

src_test() {
	emake tests
}

src_install() {
	emake install DESTDIR="${D}"
	einstalldocs
	find "${D}" -name '*.la' -delete || die
}
