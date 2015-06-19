# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ctypesgen/ctypesgen-0_p72.ebuild,v 1.21 2012/05/12 01:16:16 aballier Exp $

EAPI="3"
PYTHON_DEPEND="2:2.5"
SUPPORT_PYTHON_ABIS="1"

inherit distutils

DESCRIPTION="Python wrapper generator for ctypes"
HOMEPAGE="http://code.google.com/p/ctypesgen/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd"
IUSE=""

DEPEND=""
RDEPEND=""
# 2.4 restricted due to usage of ctypes module.
RESTRICT_PYTHON_ABIS="2.4 3.*"

PYTHON_MODNAME="ctypesgencore"
