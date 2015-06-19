# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/horde-mimp/horde-mimp-1.0.1.ebuild,v 1.2 2007/07/12 14:28:08 gustavoz Exp $

HORDE_PHP_FEATURES="imap"
HORDE_MAJ="-h3"
inherit horde

DESCRIPTION="Horde MIMP provides minimalist webmail access suitable for mobile devices"

KEYWORDS="~alpha ~amd64 ~hppa ~ppc sparc ~x86"
IUSE="crypt"

DEPEND=""
RDEPEND=">=www-apps/horde-3
	crypt? ( app-crypt/gnupg )"
