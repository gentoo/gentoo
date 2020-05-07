# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_6  )
PYTHON_REQ_USE="xml"

inherit distutils-r1

DESCRIPTION="Command line client for Amazon S3"
HOMEPAGE="https://s3tools.org/s3cmd"
SRC_URI="mirror://sourceforge/s3tools/${P/_/-}.tar.gz"
LICENSE="GPL-2"
SLOT="0"

KEYWORDS="amd64 ~ia64 x86 ~x64-macos"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/python-magic[${PYTHON_USEDEP}]"

S="$WORKDIR/${P/_/-}"
