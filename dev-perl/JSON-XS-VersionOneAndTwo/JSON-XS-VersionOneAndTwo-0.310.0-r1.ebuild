# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/JSON-XS-VersionOneAndTwo/JSON-XS-VersionOneAndTwo-0.310.0-r1.ebuild,v 1.1 2014/08/26 17:29:06 axs Exp $

EAPI=5

MODULE_AUTHOR=LBROCARD
MODULE_VERSION=0.31
inherit perl-module

DESCRIPTION="Support versions 1 and 2 of JSON::XS"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE="test"

RDEPEND="dev-perl/JSON-XS"
DEPEND="
	test? (
		${RDEPEND}
		dev-perl/Test-Pod
	)"

SRC_TEST=do
