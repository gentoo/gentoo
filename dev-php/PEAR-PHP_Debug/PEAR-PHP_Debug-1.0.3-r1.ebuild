# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-PHP_Debug/PEAR-PHP_Debug-1.0.3-r1.ebuild,v 1.1 2012/01/18 21:57:34 mabi Exp $

EAPI="4"

inherit php-pear-r1

DESCRIPTION="Provides traces, timings, executed queries, watched variables etc. "

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="minimal"

RDEPEND="!minimal? ( dev-php/PEAR-Text_Highlighter
		    dev-php/PEAR-Services_W3C_HTMLValidator )"
