# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Text_CAPTCHA/PEAR-Text_CAPTCHA-0.5.0.ebuild,v 1.4 2015/02/25 15:39:21 ago Exp $

EAPI=5

inherit php-pear-r1

DESCRIPTION="Generation of CAPTCHAs"
LICENSE="BSD"
SLOT="0"

KEYWORDS="amd64 x86"
IUSE="minimal"

RDEPEND=">=dev-php/PEAR-Text_Password-1.1.1
	dev-lang/php[gd,truetype]
	!minimal? ( dev-php/PEAR-Numbers_Words
		    dev-php/PEAR-Text_Figlet
		    >=dev-php/PEAR-Image_Text-0.7.0 )"
