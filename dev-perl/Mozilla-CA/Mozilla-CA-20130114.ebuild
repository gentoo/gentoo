# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mozilla-CA/Mozilla-CA-20130114.ebuild,v 1.2 2014/08/20 17:22:41 ssuominen Exp $

EAPI=5

MODULE_AUTHOR=ABH
MODULE_VERSION=20130114
inherit perl-module

DESCRIPTION="Mozilla's CA cert bundle in PEM format"

LICENSE="MPL-1.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}"

SRC_TEST="do"
