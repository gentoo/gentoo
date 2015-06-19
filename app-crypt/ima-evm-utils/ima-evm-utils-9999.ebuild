# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-crypt/ima-evm-utils/ima-evm-utils-9999.ebuild,v 1.1 2013/02/10 10:23:44 swift Exp $

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
