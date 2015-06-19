# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-Google-SafeBrowsing-UpdateRequest/Net-Google-SafeBrowsing-UpdateRequest-1.60.0-r1.ebuild,v 1.1 2014/08/24 02:06:02 axs Exp $

EAPI=5

MODULE_AUTHOR=DANBORN
MODULE_VERSION=1.06
inherit perl-module

DESCRIPTION="Update a Google SafeBrowsing table"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 ppc x86"
IUSE="test"

RDEPEND="dev-perl/libwww-perl
	 >=dev-perl/Net-Google-SafeBrowsing-Blocklist-1.04"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-Pod )"

SRC_TEST="do"
