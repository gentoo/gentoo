# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Log-TraceMessages/Log-TraceMessages-1.400.0-r1.ebuild,v 1.1 2014/08/23 21:29:54 axs Exp $

EAPI=5

MODULE_AUTHOR=EDAVIS
MODULE_VERSION=1.4
inherit perl-module

DESCRIPTION="Logging/debugging aid"

SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-linux"
IUSE=""

RDEPEND=">=dev-perl/HTML-FromText-1.004"
DEPEND="${RDEPEND}"

SRC_TEST="do"
