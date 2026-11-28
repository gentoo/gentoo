# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2

DESCRIPTION="Simple calendar and agenda application"
HOMEPAGE="https://github.com/poroussel/simpleagenda"
SRC_URI="https://github.com/poroussel/simpleagenda/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="dbus"

DEPEND="dev-libs/libical:=
	>=virtual/gnustep-back-0.20.0
	dbus? ( gnustep-libs/dbuskit )"
RDEPEND="${DEPEND}"

src_configure() {
	egnustep_env
	econf $(use_enable dbus dbuskit)
}
