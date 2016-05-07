# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.5
inherit netsurf

DESCRIPTION="mapping tool for UTF-8 strings"
HOMEPAGE="http://www.netsurf-browser.org/"
SRC_URI="${NETSURF_BUILDSYSTEM_SRC_URI}
	http://download.netsurf-browser.org/libs/releases/${P/_p/-}-src.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"
