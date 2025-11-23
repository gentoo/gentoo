# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )
DISTUTILS_USE_PEP517=setuptools
PYTHON_REQ_USE="xml(+)"

inherit distutils-r1 bash-completion-r1

DESCRIPTION="Super S3 command line tool"
HOMEPAGE="https://github.com/bloomreach/s4cmd"
SRC_URI="
	https://github.com/bloomreach/s4cmd/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
	https://github.com/bloomreach/s4cmd/pull/162.patch -> ${P}-py3-iter.patch
	https://github.com/bloomreach/s4cmd/pull/310.patch -> ${P}-botocore-fix.patch
"
S="${WORKDIR}/${P/_/-}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-python/boto3[${PYTHON_USEDEP}]
	dev-python/pytz[${PYTHON_USEDEP}]
"

PATCHES=(
	"${DISTDIR}/${P}-botocore-fix.patch"
	"${DISTDIR}/${P}-py3-iter.patch"
)

src_install() {
	distutils-r1_src_install
	dobashcomp data/bash-completion/s4cmd
	rm -f "${D}"/usr/bin/s4cmd.py
}
