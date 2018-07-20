# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
NETSURF_COMPONENT_TYPE=binary
NETSURF_BUILDSYSTEM=buildsystem-1.6
inherit netsurf

DESCRIPTION="generate javascript to dom bindings from w3c webidl files"
HOMEPAGE="http://www.netsurf-browser.org/"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc"
IUSE=""

DEPEND="virtual/yacc"
