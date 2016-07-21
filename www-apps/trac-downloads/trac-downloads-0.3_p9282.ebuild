# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

PYTHON_DEPEND="2"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.*"

inherit distutils

TRAC_PV="0.12"
MY_DIR="downloadsplugin/${TRAC_PV}"
MY_REV="${PV#*_p}"

DESCRIPTION="Project release downloads plugin for Trac"
HOMEPAGE="http://trac-hacks.org/wiki/DownloadsPlugin"
SRC_URI="http://trac-hacks.org/changeset/${MY_REV}/${MY_DIR}?old_path=/&filename=${MY_DIR}&format=zip
	-> ${P}.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools
	app-arch/unzip"
RDEPEND="=www-apps/trac-${TRAC_PV}*
	>=www-apps/trac-tags-0.6"

S="${WORKDIR}/${MY_DIR}"
