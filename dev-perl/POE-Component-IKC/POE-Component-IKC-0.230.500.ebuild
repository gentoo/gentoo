# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/POE-Component-IKC/POE-Component-IKC-0.230.500.ebuild,v 1.1 2013/08/25 10:59:03 patrick Exp $

EAPI=5

MODULE_AUTHOR=GWYN
MODULE_VERSION=0.2305
inherit perl-module

DESCRIPTION="POE Inter-Kernel Communication"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-perl/POE-API-Peek-1.34
	dev-perl/POE
	dev-perl/Devel-Size
"
DEPEND="${RDEPEND}"
