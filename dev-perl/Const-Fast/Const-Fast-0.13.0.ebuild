# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Const-Fast/Const-Fast-0.13.0.ebuild,v 1.6 2014/07/30 21:20:39 zlogene Exp $

EAPI=5

MODULE_AUTHOR=LEONT
MODULE_VERSION=0.013
inherit perl-module

DESCRIPTION="Facility for creating read-only scalars, arrays, and hashes"

SLOT="0"
KEYWORDS="amd64 arm ppc x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-perl/Sub-Exporter
	dev-perl/Sub-Exporter-Progressive
"
DEPEND="${RDEPEND}
	test? (
		>=dev-perl/Test-Exception-0.290.0
	)
"

SRC_TEST=do
