# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=HDP
MODULE_VERSION=0.072
inherit perl-module

DESCRIPTION="Replacement for if (\$foo eq 'bar')"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-perl/Sub-Install
	dev-perl/Sub-Exporter
	dev-perl/Class-Data-Inheritable
	dev-perl/Class-Accessor"
RDEPEND="${DEPEND}"
