# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MY_P=${P/_/-}

if [[ "${PV}" != "9999" ]] ; then
	SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
else
	inherit git-r3
	EGIT_REPO_URI="https://git.enlightenment.org/apps/${PN}.git"
fi

inherit meson

DESCRIPTION="Feature rich terminal emulator using the Enlightenment Foundation Libraries"
HOMEPAGE="https://www.enlightenment.org/p.php?p=about/terminology"

LICENSE="BSD-2"
SLOT="0"
IUSE=""

RDEPEND=">=dev-libs/efl-1.18[X]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
