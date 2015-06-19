# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-PHP_CodeSniffer/PEAR-PHP_CodeSniffer-2.3.0.ebuild,v 1.1 2015/03/06 02:49:49 grknight Exp $

EAPI="5"

inherit php-pear-r1

DESCRIPTION="Tokenises PHP code and detects violations of a defined set of coding standards"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RDEPEND=">=dev-lang/php-5.1.2:*[cli]"
