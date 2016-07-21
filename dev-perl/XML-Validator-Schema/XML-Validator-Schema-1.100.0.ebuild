# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR="SAMTREGAR"
MODULE_VERSION="1.10"

inherit perl-module

DESCRIPTION="Validate XML against a subset of W3C XML Schema"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-perl/XML-SAX
	dev-perl/Tree-DAG_Node
	dev-perl/XML-Filter-BufferText"
DEPEND="${RDEPEND}"

SRC_TEST="do"
