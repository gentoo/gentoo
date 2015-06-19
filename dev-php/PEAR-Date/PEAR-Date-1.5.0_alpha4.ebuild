# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Date/PEAR-Date-1.5.0_alpha4.ebuild,v 1.2 2014/08/10 20:46:10 slyfox Exp $

inherit php-pear-r1

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"

DESCRIPTION="Date and Time Zone classes"
LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="|| ( <dev-php/PEAR-PEAR-1.71
	dev-php/PEAR-Console_Getopt )"
RDEPEND=""
