# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-DistManifest/Test-DistManifest-1.12.0-r1.ebuild,v 1.1 2014/08/26 17:57:14 axs Exp $

EAPI=5

MODULE_AUTHOR=ETHER
MODULE_VERSION=1.012
inherit perl-module

DESCRIPTION="Author test that validates a package MANIFEST"

SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND="
	dev-perl/Module-Manifest
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-NoWarnings
	)
"

SRC_TEST="do"
