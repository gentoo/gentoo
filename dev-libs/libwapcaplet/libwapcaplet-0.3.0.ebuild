# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.5
inherit netsurf

DESCRIPTION="string internment library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libwapcaplet/"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm ~ppc ~m68k-mint"
IUSE="test"

DEPEND="test? ( >=dev-libs/check-0.9.11[${MULTILIB_USEDEP}] )"
