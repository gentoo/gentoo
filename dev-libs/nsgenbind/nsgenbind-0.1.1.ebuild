# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/nsgenbind/nsgenbind-0.1.1.ebuild,v 1.1 2014/11/15 13:28:00 xmw Exp $

EAPI=5
NETSURF_COMPONENT_TYPE=binary
NETSURF_BUILDSYSTEM=buildsystem-1.2
inherit netsurf

DESCRIPTION="generate javascript to dom bindings from w3c webidl files"
HOMEPAGE="http://www.netsurf-browser.org/"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm"
IUSE=""

DEPEND="virtual/yacc"

PATCHES=( "${FILESDIR}"/${P}-glibc2.20.patch )
