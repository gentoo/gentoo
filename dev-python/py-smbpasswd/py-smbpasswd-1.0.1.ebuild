# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="3"
PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* *-jython"

inherit distutils

DESCRIPTION="Module capable of generating both LANMAN and NT password hashes, for e.g. Samba"
HOMEPAGE="http://barryp.org/software/py-smbpasswd/"
SRC_URI="http://barryp.org/software/${PN}/files/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ia64 ppc sparc x86"
IUSE=""

DEPEND=""
RDEPEND=""
