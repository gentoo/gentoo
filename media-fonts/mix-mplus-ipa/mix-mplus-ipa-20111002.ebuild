# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-fonts/mix-mplus-ipa/mix-mplus-ipa-20111002.ebuild,v 1.1 2012/01/22 10:40:37 matsuu Exp $

EAPI="4"
inherit font

DESCRIPTION="Mixing mplus and IPA fonts"
HOMEPAGE="http://mix-mplus-ipa.sourceforge.jp/"
SRC_URI="mirror://sourceforge.jp/mix-mplus-ipa/53388/migmix-1m-${PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/53388/migmix-1p-${PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/53388/migmix-2m-${PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/53388/migmix-2p-${PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/53389/migu-1p-${PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/53389/migu-1c-${PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/53389/migu-1m-${PV}.zip
	mirror://sourceforge.jp/mix-mplus-ipa/53389/migu-2m-${PV}.zip"
#	mirror://sourceforge.jp/mix-mplus-ipa/53389/migu-1vs-${PV}.zip
#	mirror://sourceforge.jp/mix-mplus-ipa/53389/migu-2ds-${PV}.zip

LICENSE="mplus-fonts IPAfont"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}"

FONT_SUFFIX="ttf"
FONT_S="${S}"

DEPEND="app-arch/unzip"
RDEPEND=""

src_prepare() {
	mv */*.${FONT_SUFFIX} "${FONT_S}" || die
}
