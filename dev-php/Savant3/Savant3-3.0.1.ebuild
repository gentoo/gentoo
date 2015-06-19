# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/Savant3/Savant3-3.0.1.ebuild,v 1.1 2015/05/06 17:49:38 grknight Exp $

EAPI=5

inherit php-pear-lib-r1

KEYWORDS="~amd64 ~x86"

DESCRIPTION="The simple PHP template alternative to Smarty"
HOMEPAGE="http://phpsavant.com/yawiki/index.php?area=Savant3"
SRC_URI="http://phpsavant.com/get/${P}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="minimal"

DEPEND=""
RDEPEND="!minimal? ( >=dev-php/Savant3-Plugin-Form-0.2.1 )"
