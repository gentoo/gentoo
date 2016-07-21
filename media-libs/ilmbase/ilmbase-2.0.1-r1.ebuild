# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools-multilib

DESCRIPTION="OpenEXR ILM Base libraries"
HOMEPAGE="http://openexr.com/"
SRC_URI="http://download.savannah.gnu.org/releases/openexr/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/2.0.1" # 2.0.1 for the namespace off -> on switch, caused library renaming
KEYWORDS="~amd64 -arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="static-libs"

DOCS=( AUTHORS ChangeLog NEWS README )
MULTILIB_WRAPPED_HEADERS=( /usr/include/OpenEXR/IlmBaseConfig.h )
