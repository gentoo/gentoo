# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Email-LocalDelivery/Email-LocalDelivery-1.200.0-r1.ebuild,v 1.1 2014/08/26 18:00:00 axs Exp $

EAPI=5

MODULE_AUTHOR=RJBS
MODULE_VERSION=1.200
inherit perl-module

DESCRIPTION="Local delivery of RFC2822 message format and headers"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE="test"

RDEPEND="dev-perl/Email-Simple
	dev-perl/Email-FolderType
	dev-perl/File-Path-Expand"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST="do"
