# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/zh-kcfonts/zh-kcfonts-1.05-r3.ebuild,v 1.5 2011/06/14 11:46:09 pva Exp $

S="${WORKDIR}"
inherit eutils font toolchain-funcs

MY_P="kcfonts-${PV}"
DESCRIPTION="Kuo Chauo Chinese Fonts collection in BIG5 encoding"
SRC_URI="ftp://freebsd.sinica.edu.tw/pub/distfiles/${MY_P}.tar.gz
		ftp://wm28.csie.ncu.edu.tw/pub/distfiles/${MY_P}.tar.gz
		mirror://gentoo/${MY_P}-freebsd-aa_ad.patch.gz"
HOMEPAGE="http://freebsd.sinica.edu.tw/"
# no real homepage exists, but this was written by Taiwanese FreeBSD devs

LICENSE="freedist"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc s390 sh sparc x86 ~x86-fbsd"
IUSE=""

# Only installs fonts
RESTRICT="strip binchecks"

DEPEND="x11-apps/bdftopcf"
RDEPEND=""

FONT_SUFFIX="pcf.gz"
DOCS="00README Xdefaults.*"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${WORKDIR}/${MY_P}-freebsd-aa_ad.patch"
	epatch "${FILESDIR}/${MY_P}-code-fixups.patch"
	epatch "${FILESDIR}/${MY_P}-parallel-make.patch"
}

src_compile() {
	emake CC="$(tc-getCC)" || die
}
