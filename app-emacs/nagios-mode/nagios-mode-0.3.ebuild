# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit elisp

DESCRIPTION="Major mode for editing Nagios configuration files"
HOMEPAGE="http://michael.orlitzky.com/code/nagios-mode.php"
SRC_URI="http://michael.orlitzky.com/code/releases/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

SITEFILE="50${PN}-gentoo.el"
DOCS="ChangeLog README test_suite.cfg"
