# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/d/D}"
inherit font

# $PV is a build number, use fontforge to find it out. 113 was taken from:
# https://android.git.kernel.org/?p=platform/frameworks/base.git;a=tree;f=data/fonts;hb=HEAD
DESCRIPTION="Font family from Google's Android project"
HOMEPAGE="https://www.cosmix.org/software/#Drois%20Sans%20Mono%20%28Slashed%20Zero%29"
SRC_URI="mirror://gentoo/${P}-r1.tar.bz2
	mirror://gentoo/${MY_PN}SansMonoSlashed-112_p1.ttf.bz2
	mirror://gentoo/${MY_PN}SansMonoDotted-112_p1.ttf.bz2"
S="${WORKDIR}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm arm64 ppc ppc64 x86"
IUSE=""

FONT_CONF=(
	"${FILESDIR}/59-google-droid-sans-mono.conf"
	"${FILESDIR}/59-google-droid-sans.conf"
	"${FILESDIR}/59-google-droid-serif.conf"
)
FONT_SUFFIX="ttf"

src_prepare() {
	default
	mv "${WORKDIR}/${MY_PN}SansMonoSlashed-112_p1.ttf" \
		"${S}/${MY_PN}SansMonoSlashed.ttf" || die
	mv "${WORKDIR}/${MY_PN}SansMonoDotted-112_p1.ttf" \
		"${S}/${MY_PN}SansMonoDotted.ttf" || die
	rm Ahem.ttf || die # bug 530158
}
