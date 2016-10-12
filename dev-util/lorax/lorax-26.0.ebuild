# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Redhat Tools for creating disk, filesystem, and iso images"
HOMEPAGE="https://github.com/rhinstaller/lorax"
SRC_URI="https://github.com/rhinstaller/lorax/archive/${P}-1.tar.gz -> ${P}-1.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${WORKDIR}"/"${PN}-${P}-1"

DEPEND=""
RDEPEND="${DEPEND}"
