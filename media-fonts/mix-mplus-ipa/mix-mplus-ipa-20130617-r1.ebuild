# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PV="${PV/_p/-}"
inherit font

DESCRIPTION="Mixing mplus and IPA fonts"
HOMEPAGE="https://mix-mplus-ipa.osdn.jp/"
SRC_URI="mirror://sourceforge.jp/mix-mplus-ipa/59021/migmix-1m-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59021/migmix-1p-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59021/migmix-2m-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59021/migmix-2p-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59022/migu-1p-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59022/migu-1c-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59022/migu-1m-${MY_PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/59022/migu-2m-${MY_PV}.zip"
S="${WORKDIR}"

LICENSE="mplus-fonts IPAfont"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"

FONT_SUFFIX="ttf"

src_prepare() {
	default
	mv */*.${FONT_SUFFIX} . || die
}
