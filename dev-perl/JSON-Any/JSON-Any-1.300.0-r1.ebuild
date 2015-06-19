# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/JSON-Any/JSON-Any-1.300.0-r1.ebuild,v 1.1 2014/08/26 17:28:23 axs Exp $

EAPI=5

MODULE_AUTHOR=PERIGRIN
MODULE_VERSION=1.30
inherit perl-module

DESCRIPTION="Wrapper Class for the various JSON classes"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos ~x86-solaris"
IUSE=""

DEPEND="
	dev-perl/JSON
	>=dev-perl/JSON-XS-2.3
"
RDEPEND="${DEPEND}"

SRC_TEST=do
