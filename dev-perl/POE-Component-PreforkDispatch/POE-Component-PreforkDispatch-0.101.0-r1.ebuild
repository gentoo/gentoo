# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/POE-Component-PreforkDispatch/POE-Component-PreforkDispatch-0.101.0-r1.ebuild,v 1.2 2015/06/13 22:30:44 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=EWATERS
MODULE_VERSION=0.101
inherit perl-module

DESCRIPTION="Preforking task dispatcher"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Error
	dev-perl/IO-Capture
	dev-perl/Params-Validate
	dev-perl/POE"
DEPEND="${RDEPEND}
	dev-perl/Module-Build"
