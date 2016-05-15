# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

KMNAME="kde-workspace"
KMMODULE="libs/kdm"
inherit kde4-meta

DESCRIPTION="Conversation widgets for KDM greeter"
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="debug"

DEPEND="
	!<kde-base/kdm-4.11.17-r1:4
"

RDEPEND="${DEPEND}"
