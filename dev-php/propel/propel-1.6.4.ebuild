# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

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
