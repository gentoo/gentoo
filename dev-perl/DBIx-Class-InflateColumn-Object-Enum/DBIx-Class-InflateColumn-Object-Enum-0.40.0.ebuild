# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=JMMILLS
MODULE_VERSION=0.04
MODULE_A_EXT=tgz
inherit perl-module

DESCRIPTION="Allows a DBIx::Class user to define a Object::Enum column"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/DBIx-Class
	dev-perl/Object-Enum
	dev-perl/DBICx-TestDatabase"
RDEPEND="${DEPEND}"
