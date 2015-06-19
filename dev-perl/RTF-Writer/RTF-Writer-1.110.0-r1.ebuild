# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/RTF-Writer/RTF-Writer-1.110.0-r1.ebuild,v 1.1 2014/08/26 17:32:15 axs Exp $

EAPI=5

MODULE_AUTHOR=SBURKE
MODULE_VERSION=1.11
inherit perl-module

DESCRIPTION="RTF::Writer - for generating documents in Rich Text Format"

SLOT="0"
KEYWORDS="~amd64 x86"
IUSE=""

RDEPEND="dev-perl/ImageSize"
DEPEND="${RDEPEND}"

SRC_TEST="do"
