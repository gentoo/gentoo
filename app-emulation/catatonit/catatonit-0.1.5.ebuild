# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="A container init that is so simple it's effectively brain-dead"
HOMEPAGE="https://github.com/openSUSE/catatonit"
MY_P=${PN}-${PV}
SRC_URI="https://github.com/openSUSE/catatonit/archive/v${PV}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="GPL-3"
SLOT="0"

KEYWORDS="~amd64"

src_prepare() {
	./autogen.sh || die
	default
}
