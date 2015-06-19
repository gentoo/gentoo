# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/String-RewritePrefix/String-RewritePrefix-0.6.0-r1.ebuild,v 1.1 2014/08/26 18:00:47 axs Exp $

EAPI=5

MODULE_AUTHOR="RJBS"
MODULE_VERSION=0.006
inherit perl-module

DESCRIPTION="Rewrite strings based on a set of known prefixes"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-perl/Sub-Exporter-0.982.0"
DEPEND="${RDEPEND}"

SRC_TEST="do"
