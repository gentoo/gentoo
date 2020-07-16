# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit unpacker

DESCRIPTION="Extra themes for IceWM"
HOMEPAGE="https://github.com/bbidulock/icewm-extra-themes"
SRC_URI="https://github.com/bbidulock/icewm-extra-themes/releases/download/${PV}/${P}.tar.lz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-wm/icewm"
DEPEND="$(unpacker_src_uri_depends)"
