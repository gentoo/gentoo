# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MATE_LA_PUNT="yes"

inherit mate

if [[ ${PV} != 9999 ]]; then
	KEYWORDS="~amd64 ~arm ~x86"
fi

DESCRIPTION="User documentation for MATE Desktop"
LICENSE="FDL-1.1+ GPL-2+"
SLOT="0"

COMMON_DEPEND=""

RDEPEND="${COMMON_DEPEND}
	gnome-extra/yelp
	virtual/libintl
"

DEPEND="${COMMON_DEPEND}
	app-text/yelp-tools
	>=sys-devel/gettext-0.19.8:*
	virtual/pkgconfig:*
	!!mate-base/mate-desktop[user-guide]"
