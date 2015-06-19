# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-fs/nfstest/nfstest-1.0.2.ebuild,v 1.2 2015/04/08 18:16:09 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

MY_PN="NFStest"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Tools for testing either the NFS client or the NFS server"
HOMEPAGE="http://wiki.linux-nfs.org/wiki/index.php/NFStest"
SRC_URI="http://www.linux-nfs.org/~mora/nfstest/releases/${MY_P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="net-fs/nfs-utils"
DEPEND=""

S="${WORKDIR}"/${MY_P}
