# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit php-pear-r1

DESCRIPTION="SOAP Client/Server for PHP 4"

LICENSE="PHP-2.02"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~s390 ~sh sparc x86"
IUSE="minimal"

RDEPEND=">=dev-php/PEAR-HTTP_Request-1.2.4-r1
	!minimal? ( dev-php/PEAR-Mail
		    >=dev-php/PEAR-Mail_Mime-1.3.1-r1
		    >=dev-php/PEAR-Net_DIME-0.3-r1 )"
