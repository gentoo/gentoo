# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Format-ISO8601/DateTime-Format-ISO8601-0.80.0-r1.ebuild,v 1.4 2015/06/13 22:36:17 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=JHOBLITT
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="Parses ISO8601 formats"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-fbsd"
IUSE="test"

RDEPEND="dev-perl/DateTime
	dev-perl/DateTime-Format-Builder"
DEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? (
		dev-perl/Test-Pod
		dev-perl/File-Find-Rule
		dev-perl/Test-Distribution
	)"

SRC_TEST=do
