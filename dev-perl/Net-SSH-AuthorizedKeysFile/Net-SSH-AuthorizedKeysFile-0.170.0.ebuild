# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-SSH-AuthorizedKeysFile/Net-SSH-AuthorizedKeysFile-0.170.0.ebuild,v 1.1 2015/02/03 17:44:04 robbat2 Exp $

EAPI=5

MODULE_AUTHOR=MSCHILLI
MODULE_VERSION=${PV:0:4}
inherit perl-module

DESCRIPTION="Read and modify ssh's authorized_keys files"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-perl/Log-Log4perl"
DEPEND="${RDEPEND}"

SRC_TEST="do"
