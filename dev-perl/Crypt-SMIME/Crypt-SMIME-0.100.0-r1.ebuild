# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MIKAGE
MODULE_VERSION=0.10
inherit perl-module

DESCRIPTION="S/MIME sign, verify, encrypt and decrypt"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-libs/openssl"
DEPEND="${RDEPEND}"
#	test? (
#		dev-perl/Test-Exception
#	)"

#SRC_TEST=do
