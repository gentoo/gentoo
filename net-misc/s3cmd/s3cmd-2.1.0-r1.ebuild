# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_7 python3_8 python3_9 )
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1

DESCRIPTION="Command line client for Amazon S3"
HOMEPAGE="https://s3tools.org/s3cmd"
SRC_URI="mirror://sourceforge/s3tools/${P/_/-}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ia64 x86 ~amd64-linux ~x64-macos"

RDEPEND="
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/python-magic[${PYTHON_USEDEP}]"

S="${WORKDIR}/${P/_/-}"

PATCHES=( "${FILESDIR}/${P}-fix-compatibility-with-Python-3.9.patch" )
