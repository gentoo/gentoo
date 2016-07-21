# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://linux-ima.git.sourceforge.net/gitroot/linux-ima/ima-evm-utils.git"
EGIT_BOOTSTRAP="autogen.sh"

inherit git-2 eutils

DESCRIPTION="Supporting tools for IMA and EVM"
HOMEPAGE="http://linux-ima.sourceforge.net"
SRC_URI=""

DEPEND="sys-apps/keyutils"
RDEPEND="${DEPEND}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""
