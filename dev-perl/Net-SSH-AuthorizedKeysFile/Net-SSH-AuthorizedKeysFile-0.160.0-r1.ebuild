# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Net-SSH-AuthorizedKeysFile/Net-SSH-AuthorizedKeysFile-0.160.0-r1.ebuild,v 1.1 2014/08/23 02:12:05 axs Exp $

EAPI=5

MODULE_AUTHOR=MSCHILLI
MODULE_VERSION=0.16
inherit perl-module

DESCRIPTION="Read and modify ssh's authorized_keys files"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="dev-perl/Log-Log4perl"
DEPEND="${RDEPEND}"

SRC_TEST="do"
