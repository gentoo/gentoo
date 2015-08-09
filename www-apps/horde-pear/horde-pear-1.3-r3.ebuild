# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

DESCRIPTION="Meta package for the PEAR packages required by Horde"
HOMEPAGE="http://pear.php.net/"

LICENSE="metapackage"
SLOT="1"
# when unmasking for an arch
# double check none of the deps are still masked!
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 s390 sparc x86"
IUSE=""

S=${WORKDIR}

RDEPEND="dev-php/PEAR-Log
	dev-php/PEAR-Net_Sieve
	dev-php/PEAR-Mail_Mime
	>=dev-php/PEAR-DB-1.6.0
	dev-php/PEAR-File
	dev-php/PEAR-Date
	>=dev-php/PEAR-Services_Weather-1.3.1
	dev-php/PEAR-Mail"
