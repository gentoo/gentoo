# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit font

MY_PN="${PN/d/D}"

# $PV is a build number, use fontforge to find it out. 113 was taken from:
# https://android.git.kernel.org/?p=platform/frameworks/base.git;a=tree;f=data/fonts;hb=HEAD
DESCRIPTION="Font family from Google's Android project"
HOMEPAGE="https://code.google.com/android/RELEASENOTES.html http://www.cosmix.org/software/"
SRC_URI="mirror://gentoo/${P}-r1.tar.bz2
	mirror://gentoo/${MY_PN}SansMonoSlashed-112_p1.ttf.bz2
	mirror://gentoo/${MY_PN}SansMonoDotted-112_p1.ttf.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm ~arm64 ppc ppc64 x86"
IUSE=""

S="${WORKDIR}/${PN}"
FONT_S="${S}"
FONT_SUFFIX="ttf"
FONT_CONF=(
	"${FILESDIR}/59-google-droid-sans-mono.conf"
	"${FILESDIR}/59-google-droid-sans.conf"
	"${FILESDIR}/59-google-droid-serif.conf"
)

src_prepare() {
	mv "${WORKDIR}/${MY_PN}SansMonoSlashed-112_p1.ttf" \
		"${S}/${MY_PN}SansMonoSlashed.ttf"
	mv "${WORKDIR}/${MY_PN}SansMonoDotted-112_p1.ttf" \
		"${S}/${MY_PN}SansMonoDotted.ttf"
	rm Ahem.ttf # bug 530158
}
