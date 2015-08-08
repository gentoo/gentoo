# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
