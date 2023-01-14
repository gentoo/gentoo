# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )

inherit distutils-r1

DESCRIPTION="Python library for interacting with various VCS systems"
HOMEPAGE="https://wiki.ros.org/vcstools"
SRC_URI="
	http://download.ros.org/downloads/${PN}/${P}.tar.gz
	https://github.com/vcstools/vcstools/archive/${PV}.tar.gz -> ${P}.tar.gz
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"
BDEPEND="test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-vcs/git
		dev-vcs/mercurial
		dev-vcs/subversion
	)
"

PATCHES=( "${FILESDIR}/yaml.patch" )

distutils_enable_tests nose

src_prepare() {
	# Those fail because of broken upstream testing
	rm test/test_bzr.py || die
	sed -e 's/test_checkout_timeout/_&/' -i test/test_git.py || die

	distutils-r1_src_prepare
}

src_test() {
	# From travis.yml
	# Set git config to silence some stuff in the tests
	git config --global user.email "foo@example.com" || die
	git config --global user.name "Foo Bar" || die
	# Set the hg user
	cat > ~/.hgrc <<- EOF || die
		[ui]
		username = Your Name <your@mail.com>
	EOF

	distutils-r1_src_test
}
