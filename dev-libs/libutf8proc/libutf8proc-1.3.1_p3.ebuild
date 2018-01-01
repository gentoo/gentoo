# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.6
inherit netsurf

DESCRIPTION="mapping tool for UTF-8 strings"
HOMEPAGE="http://www.netsurf-browser.org/"
SRC_URI="${NETSURF_BUILDSYSTEM_SRC_URI}
	http://download.netsurf-browser.org/libs/releases/${P/_p/-}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${PN}-1.3.1_p2-overrun.patch )

S="${WORKDIR}/${P/_p/-}"
