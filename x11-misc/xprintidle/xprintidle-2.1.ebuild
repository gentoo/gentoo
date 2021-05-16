# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Prints user's X server idle time in milliseconds"
HOMEPAGE="https://github.com/lucianposton/xprintidle"
SRC_URI="https://github.com/lucianposton/xprintidle/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

DEPEND="
	x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXScrnSaver
	"
RDEPEND="${DEPEND}"

DOCS=(
	AUTHORS
	ChangeLog
	NEWS
)
