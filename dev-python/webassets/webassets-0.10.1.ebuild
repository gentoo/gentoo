# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )
inherit distutils-r1

DESCRIPTION="Asset management for Python web development"
HOMEPAGE="https://github.com/miracle2k/webassets"
SRC_URI="https://github.com/miracle2k/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=""
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
