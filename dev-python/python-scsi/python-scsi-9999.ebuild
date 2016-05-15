# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{3,4,5}} )

inherit distutils-r1 git-r3

DESCRIPTION="Access to SG_IO scsi devices"
HOMEPAGE="https://github.com/rosjat/python-scsi/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/rosjat/python-scsi.git"

SLOT="0"
LICENSE="LGPL-2.1"
KEYWORDS=""
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
