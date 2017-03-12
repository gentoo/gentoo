# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

MY_P=${P/_/-}

if [[ "${PV}" == "9999" ]] ; then
	EGIT_SUB_PROJECT="apps"
	EGIT_URI_APPEND="${PN}"
else
	SRC_URI="https://download.enlightenment.org/rel/apps/${PN}/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi

inherit enlightenment

DESCRIPTION="Feature rich terminal emulator using the Enlightenment Foundation Libraries"
HOMEPAGE="https://www.enlightenment.org/p.php?p=about/terminology"

RDEPEND=">=dev-libs/efl-1.18"
DEPEND="${RDEPEND}
	virtual/pkgconfig"
