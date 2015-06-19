# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-ftp/pybootd/pybootd-1.5.0_pre20110524131526.ebuild,v 1.1 2014/09/04 18:58:23 vapier Exp $

EAPI="5"
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

GIT_HASH="7fd7d045fd4b4cdeebf4d07c1c5cd9649c2172b8"

DESCRIPTION="Simplified BOOTP/DHCP/PXE/TFTP server"
HOMEPAGE="https://github.com/eblot/pybootd"
SRC_URI="https://github.com/eblot/pybootd/archive/${GIT_HASH:0:6}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=dev-python/netifaces-0.5"
DEPEND=""

S="${WORKDIR}/pybootd-${GIT_HASH}"

PATCHES=(
	"${FILESDIR}"/${PN}-scripts.patch
)
