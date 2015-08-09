# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit elisp

MY_PV=${PV/./_}
MY_PV=${MY_PV/_beta/b}

DESCRIPTION="An Emacs mode for editing Relax NG compact schema files"
HOMEPAGE="http://www.pantor.com/"
SRC_URI="http://www.pantor.com/RncMode-${MY_PV}.tgz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE=""

SITEFILE=50${PN}-gentoo.el

S="${WORKDIR}"
