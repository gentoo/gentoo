# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 git-r3

DESCRIPTION="Python bindings for libiscsi"
HOMEPAGE="https://github.com/sahlberg/libiscsi-python"
SRC_URI=""
EGIT_REPO_URI="https://github.com/sahlberg/libiscsi-python.git"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS=""
IUSE=""

RDEPEND="net-libs/libiscsi"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"
