# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit xorg-2

DESCRIPTION="X.Org rstart application"
KEYWORDS="amd64 arm ~mips ppc ppc64 ~s390 ~sh ~sparc x86"
IUSE=""

RDEPEND="x11-proto/xproto"
DEPEND="${RDEPEND}"
