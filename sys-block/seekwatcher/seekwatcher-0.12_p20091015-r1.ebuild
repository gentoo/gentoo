# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit eutils distutils-r1

DESCRIPTION="generates graphs from blktrace to help visualize IO patterns and performance"
HOMEPAGE="http://oss.oracle.com/~mason/seekwatcher/"
#SRC_URI="http://oss.oracle.com/~mason/seekwatcher/${P}.tar.bz2"
SRC_URI="https://dev.gentoo.org/~slyfox/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="dev-python/pyrex"
RDEPEND="
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/numpy[${PYTHON_USEDEP}]
	>=sys-block/btrace-0.0.20070730162628
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

S=${WORKDIR}/${PN}-b392aeaf693b # hg snapshot

PATCHES=("${FILESDIR}"/${P}-dash-fix.patch)
