# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=DOMIZIO
MODULE_VERSION=1.36
inherit perl-module

DESCRIPTION="Framework to build simple or complex web-apps"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=dev-perl/OOTools-2.21
	>=dev-perl/IO-Util-1.5"
RDEPEND="${DEPEND}"
