# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="6"

inherit php-pear-r1

DESCRIPTION="GNU Privacy Guard (GnuPG)"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=">=dev-lang/php-5.2.1:*[posix,unicode]"
RDEPEND="${DEPEND}
	app-crypt/gnupg
	dev-php/PEAR-Console_CommandLine"
