# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR plugin: fork of vdr-pilot - navigate through channels with skinnable design"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://vdr.websitec.de/download/${PN}/${P}.tgz"

KEYWORDS="~amd64 ~x86"
SLOT="0"
LICENSE="GPL-2"
IUSE=""

DEPEND=">=media-video/vdr-1.3.36"

PATCHES=("${FILESDIR}/${P}-vdr-1.5.diff")

src_prepare() {
	vdr-plugin-2_src_prepare

	sed -i pilotskin.c -e "s:RegisterI18n://RegisterI18n:"
	vdr_remove_i18n_include pilotskin.c
}
