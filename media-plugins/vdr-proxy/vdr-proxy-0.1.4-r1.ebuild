# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit vdr-plugin-2

DESCRIPTION="VDR Plugin: enable grouping of menu entries, online load/unload"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://vdr.websitec.de/download/${PN}/${P}.tgz"
LICENSE="GPL-2"

KEYWORDS="x86"
IUSE=""
SLOT="0"

DEPEND=">=media-video/vdr-1.3.23"
