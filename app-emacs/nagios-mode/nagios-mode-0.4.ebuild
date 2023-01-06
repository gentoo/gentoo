# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit elisp

DESCRIPTION="Major mode for editing Nagios configuration files"
HOMEPAGE="http://michael.orlitzky.com/code/nagios-mode.xhtml"
SRC_URI="http://michael.orlitzky.com/code/releases/${P}.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

SITEFILE="50${PN}-gentoo.el"
DOCS="ChangeLog README test_suite.cfg"
