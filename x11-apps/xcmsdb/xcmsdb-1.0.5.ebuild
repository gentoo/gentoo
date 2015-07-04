# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-apps/xcmsdb/xcmsdb-1.0.5.ebuild,v 1.1 2015/07/04 10:37:16 mrueg Exp $

EAPI=5

inherit xorg-2

DESCRIPTION="Device Color Characterization utility for X Color Management System"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}"
