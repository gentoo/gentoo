# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils

DESCRIPTION="Defragmenter that runs in userspace while the system is used"
HOMEPAGE="http://vleu.net/shake/"
SRC_URI="https://github.com/unbrice/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc x86"
IUSE=""

RDEPEND="sys-apps/attr"
DEPEND="${RDEPEND}
	sys-apps/help2man"

PATCHES=( "${FILESDIR}"/${PN}-0.999-uclibc.patch )
