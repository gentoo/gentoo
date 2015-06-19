# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Sys-Statistics-Linux/Sys-Statistics-Linux-0.660.0-r1.ebuild,v 1.2 2015/06/13 22:05:42 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=BLOONIX
MODULE_VERSION=0.66
inherit perl-module

DESCRIPTION="Collect linux system statistics"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="dev-perl/YAML-Syck"
DEPEND="
	dev-perl/Module-Build
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST="do"

src_install() {
	perl-module_src_install

	docompress -x /usr/share/doc/$PF/examples
	insinto /usr/share/doc/$PF/examples
	doins examples/*
}
