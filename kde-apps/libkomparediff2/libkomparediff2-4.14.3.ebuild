# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/kde-apps/libkomparediff2/libkomparediff2-4.14.3.ebuild,v 1.1 2015/06/04 18:44:44 kensington Exp $

EAPI=5

inherit kde4-base

DESCRIPTION="KDE library to compare files and strings"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug test"

RDEPEND="${DEPEND}
	!<=kde-base/kompare-4.11.50
"
