# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/Savant3-Plugin-Form/Savant3-Plugin-Form-0.2.1.ebuild,v 1.3 2014/08/10 20:58:37 slyfox Exp $

EAPI=4

inherit php-pear-lib-r1
MY_P="${PN//-/_}-${PV}"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="The Form Plugin for Savant3"
HOMEPAGE="http://phpsavant.com/"
SRC_URI="http://phpsavant.com/${MY_P}.tgz"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=">=dev-php/Savant3-3.0.0"

S="${WORKDIR}/${MY_P}"
