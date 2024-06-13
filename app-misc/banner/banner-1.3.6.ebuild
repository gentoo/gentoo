# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="The well known banner program for Linux"
HOMEPAGE="https://github.com/pronovic/banner"
SRC_URI="https://github.com/pronovic/${PN}/archive/BANNER_V${PV}.tar.gz"
S="${WORKDIR}/${PN}-${PN^^}_V${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"

RDEPEND="!<=games-misc/bsd-games-3"
