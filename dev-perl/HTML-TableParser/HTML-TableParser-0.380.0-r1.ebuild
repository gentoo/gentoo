# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-TableParser/HTML-TableParser-0.380.0-r1.ebuild,v 1.1 2014/08/23 02:05:10 axs Exp $

EAPI=5

MODULE_AUTHOR=DJERIUS
MODULE_VERSION=0.38
inherit perl-module

DESCRIPTION="Extract data from an HTML table"

LICENSE="GPL-3" # GPL-3+
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="test"

RDEPEND="dev-perl/HTML-Parser"
DEPEND="test? ( ${RDEPEND}
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage )"

SRC_TEST=do
