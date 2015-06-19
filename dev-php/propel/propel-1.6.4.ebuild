# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-php/propel/propel-1.6.4.ebuild,v 1.2 2014/08/10 21:05:03 slyfox Exp $

EAPI="4"

KEYWORDS="~amd64 ~x86"

DESCRIPTION="Object Persistence Layer for PHP 5"
HOMEPAGE="http://propelorm.org"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="~dev-php/propel-generator-${PV}
		~dev-php/propel-runtime-${PV}"
