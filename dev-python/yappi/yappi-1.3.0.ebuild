# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=(python3_{7..9})
DISTUTILS_USE_SETUPTOOLS=rdepend
inherit distutils-r1

# no tags on github, no tests on pypi
COMMIT_HASH="b6c7d9f0bb40b511f61bb82cc395ad9140a4f4b0"

DESCRIPTION="Yet Another Python Profiler"
HOMEPAGE="https://pypi.org/project/yappi/ https://github.com/sumerc/yappi"
SRC_URI="https://github.com/sumerc/yappi/archive/${COMMIT_HASH}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT_HASH}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

#RDEPEND="
#	$(python_gen_cond_dep 'dev-python/contextvars[${PYTHON_USEDEP}]' 'python3_6')
#"

distutils_enable_tests unittest

PATCHES=(
	"${FILESDIR}/yappi-1.2.5-warnings.patch"
	"${FILESDIR}/yappi-1.3.0-tests.patch"
)

python_prepare_all() {
	cp tests/utils.py "${S}" || die
	distutils-r1_python_prepare_all
}
