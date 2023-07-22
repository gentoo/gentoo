# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_11 )
inherit distutils-r1

CommitId=14f43ddd74099520ddcda29fac557c27a28190e6

DESCRIPTION="Detect confusable usage of unicode homoglyphs, prevent homograph attacks"
HOMEPAGE="
	https://github.com/vhf/confusable_homoglyphs/
	https://pypi.org/project/confusable_homoglyphs/
"
SRC_URI="https://github.com/vhf/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.gh.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"/${PN}-${CommitId}

distutils_enable_tests pytest
