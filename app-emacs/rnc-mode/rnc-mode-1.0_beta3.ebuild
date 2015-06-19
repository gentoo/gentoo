# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/rnc-mode/rnc-mode-1.0_beta3.ebuild,v 1.3 2007/07/04 05:52:03 ulm Exp $

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
