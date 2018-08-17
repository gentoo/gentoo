# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8} )
PYTHON_REQ_USE=sqlite
# Only needed for entry_points, per
# <https://blogs.gentoo.org/mgorny/2020/10/21/distutils_use_setuptools-qa-spam-and-more-qa-spam/>
# can become bdepend after 3.7 is gone.
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit bash-completion-r1 distutils-r1

DESCRIPTION="A simple, standards-based, cli todo (aka: task) manager"
HOMEPAGE="https://github.com/pimutils/todoman"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
PATCHES=( "${FILESDIR}/no-pytest-coverage.patch" )

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="dev-python/atomicwrites[${PYTHON_USEDEP}]
	=dev-python/click-7*[${PYTHON_USEDEP}]
	dev-python/click-log[${PYTHON_USEDEP}]
	dev-python/configobj[${PYTHON_USEDEP}]
	dev-python/humanize[${PYTHON_USEDEP}]
	dev-python/icalendar[${PYTHON_USEDEP}]
	dev-python/parsedatetime[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
	dev-python/pyxdg[${PYTHON_USEDEP}]
	dev-python/tabulate[${PYTHON_USEDEP}]
	dev-python/urwid[${PYTHON_USEDEP}]"
DEPEND="
	test? (
		dev-python/freezegun[${PYTHON_USEDEP}]
		dev-python/hypothesis[${PYTHON_USEDEP}]
	)"

DOCS=( AUTHORS.rst CHANGELOG.rst README.rst todoman.conf.sample )

distutils_enable_tests pytest

src_test() {
	# https://github.com/pimutils/todoman/issues/320
	export TZ=UTC
	distutils-r1_src_test
}

src_install() {
	distutils-r1_src_install
	dobashcomp contrib/completion/bash/_todo
	insinto /usr/share/zsh/site-functions
	doins contrib/completion/zsh/_todo
}
