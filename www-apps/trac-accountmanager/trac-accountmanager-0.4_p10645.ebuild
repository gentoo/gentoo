# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-apps/trac-accountmanager/trac-accountmanager-0.4_p10645.ebuild,v 1.1 2011/09/08 06:54:18 rafaelmartins Exp $

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

MY_DIR="accountmanagerplugin/trunk"
MY_REV="${PV#*_p}"

DESCRIPTION="A Trac plugin for manage user accounts"
HOMEPAGE="http://trac-hacks.org/wiki/AccountManagerPlugin"
SRC_URI="http://trac-hacks.org/changeset/${MY_REV}/${MY_DIR}?old_path=/&filename=${MY_DIR}&format=zip
	-> ${P}.zip"

LICENSE="BEER-WARE"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools
	app-arch/unzip"
RDEPEND=">=www-apps/trac-0.12"

S="${WORKDIR}/${MY_DIR}"
