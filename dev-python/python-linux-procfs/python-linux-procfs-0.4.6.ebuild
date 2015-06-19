# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/python-linux-procfs/python-linux-procfs-0.4.6.ebuild,v 1.3 2015/04/08 08:05:06 mgorny Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Python classes to extract information from the Linux kernel /proc files"
HOMEPAGE="https://www.kernel.org/pub/scm/libs/python/python-linux-procfs/
	https://kernel.googlesource.com/pub/scm/libs/python/python-linux-procfs/python-linux-procfs/"
SRC_URI="mirror://gentoo/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND=""
