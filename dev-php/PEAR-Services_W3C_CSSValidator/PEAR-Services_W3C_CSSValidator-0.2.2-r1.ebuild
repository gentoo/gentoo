# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/PEAR-Services_W3C_CSSValidator/PEAR-Services_W3C_CSSValidator-0.2.2-r1.ebuild,v 1.1 2012/01/18 22:02:57 mabi Exp $

EAPI="4"

inherit php-pear-r1

DESCRIPTION="Provides an object oriented interface for the W3 CSS Validator"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-php/PEAR-HTTP_Request2-0.2.0"
