# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/deplate/deplate-0.8.5.ebuild,v 1.2 2013/05/04 04:57:02 naota Exp $

EAPI=5

USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="Deplate convert wiki-like markup to latex, docbook, html, or html-slides"
HOMEPAGE="http://deplate.sourceforge.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86-fbsd"
IUSE=""

all_ruby_prepare() {
	rm bin/deplate.bat || die
}
