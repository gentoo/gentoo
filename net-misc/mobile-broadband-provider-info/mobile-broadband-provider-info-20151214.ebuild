# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit gnome.org

DESCRIPTION="Database of mobile broadband service providers"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager/MobileBroadband"

LICENSE="CC-PD"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"

DEPEND="
	test? ( dev-libs/libxml2 )
"

DOCS="README" # ChangeLog and NEWS are both dead
