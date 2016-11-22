# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://git.code.sf.net/p/linux-ima/ima-evm-utils"
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
