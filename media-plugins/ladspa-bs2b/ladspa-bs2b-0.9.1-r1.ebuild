# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

DESCRIPTION="LADSPA plugin for bs2b headphone filter"
HOMEPAGE="http://bs2b.sourceforge.net/"
SRC_URI="mirror://sourceforge/bs2b/plugins/LADSPA%20plugin/${PV}/${P}.tar.bz2"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="media-libs/ladspa-sdk
		>=media-libs/libbs2b-3.1.0"

RDEPEND="${DEPEND}"
