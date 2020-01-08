# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit font

MY_PV="${PV/_p/-}"

DESCRIPTION="Mixing mplus and IPA fonts"
HOMEPAGE="http://mix-mplus-ipa.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/mix-mplus-ipa/59021/migmix-1m-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59021/migmix-1p-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59021/migmix-2m-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59021/migmix-2p-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59022/migu-1p-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59022/migu-1c-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59022/migu-1m-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59022/migu-2m-${MY_PV}.zip"

LICENSE="mplus-fonts IPAfont"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

S="${WORKDIR}"

FONT_SUFFIX="ttf"
FONT_S="${S}"

DEPEND="app-arch/unzip"
RDEPEND=""

src_prepare() {
	default
	mv */*.${FONT_SUFFIX} "${FONT_S}" || die
}
