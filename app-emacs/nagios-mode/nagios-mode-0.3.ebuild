# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-emacs/nagios-mode/nagios-mode-0.3.ebuild,v 1.4 2012/03/28 03:51:12 naota Exp $

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
