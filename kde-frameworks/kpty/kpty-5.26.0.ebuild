# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit kde5

DESCRIPTION="Framework for pseudo terminal devices and running child processes"
LICENSE="LGPL-2+"
KEYWORDS="amd64 ~arm x86"
IUSE=""

DEPEND="
	$(add_frameworks_dep kcoreaddons)
	$(add_frameworks_dep ki18n)
	sys-libs/libutempter
"
RDEPEND="${DEPEND}"
