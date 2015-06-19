# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Business-FedEx-DirectConnect/Business-FedEx-DirectConnect-1.10.0-r1.ebuild,v 1.1 2014/08/24 01:58:12 axs Exp $

EAPI=5

MODULE_AUTHOR=JPOWERS
MODULE_VERSION=1.01
inherit perl-module

DESCRIPTION="Interface to FedEx Ship Manager Direct"

SLOT="0"
KEYWORDS="amd64 ia64 x86"
IUSE=""

RDEPEND="dev-perl/libwww-perl
	dev-perl/Tie-StrictHash"
DEPEND="${RDEPEND}"

SRC_TEST="do"
