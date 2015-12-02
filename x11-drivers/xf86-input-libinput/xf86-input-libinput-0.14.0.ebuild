# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit xorg-2

DESCRIPTION="X.org input driver based on libinput"

KEYWORDS="~alpha amd64 ~arm ~hppa ppc ~ppc64 x86"
IUSE=""

RDEPEND=">=dev-libs/libinput-0.21.0:0="
DEPEND="${RDEPEND}"

DOCS=( "README.md" "conf/99-libinput.conf" )
