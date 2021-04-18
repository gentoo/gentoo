# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

DESCRIPTION="Python logging made (stupidly) simple"
HOMEPAGE="https://github.com/Delgan/loguru"
SRC_URI="https://github.com/Delgan/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="$(python_gen_cond_dep 'dev-python/aiocontextvars[${PYTHON_USEDEP}]' 'python3_6')"
BDEPEND="test? ( >=dev-python/colorama-0.3.4[${PYTHON_USEDEP}] )"
# filesystem buffering tests may fail
# on tmpfs with 64k PAGESZ, but pass fine on ext4
distutils_enable_tests pytest
