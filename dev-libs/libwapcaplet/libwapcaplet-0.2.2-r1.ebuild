# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libwapcaplet/libwapcaplet-0.2.2-r1.ebuild,v 1.1 2015/06/09 22:01:35 xmw Exp $

EAPI=5

NETSURF_BUILDSYSTEM=buildsystem-1.3
inherit netsurf

DESCRIPTION="string internment library, written in C"
HOMEPAGE="http://www.netsurf-browser.org/projects/libwapcaplet/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm ~m68k-mint"
IUSE="test"

DEPEND="test? ( >=dev-libs/check-0.9.11[${MULTILIB_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${P}-glibc20.patch )
