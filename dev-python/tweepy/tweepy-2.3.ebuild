# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/tweepy/tweepy-2.3.ebuild,v 1.1 2014/12/09 07:30:42 idella4 Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1 vcs-snapshot

DESCRIPTION="A Python library for accessing the Twitter API "
HOMEPAGE="http://tweepy.github.com/"
SRC_URI="https://github.com/tweepy/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples test"

#RESTRICT="test" 	#missing a required dep frpm portage

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_prepare_all() {
	# Required to avoid file collisions at install
	sed -e "s:find_packages():find_packages(exclude=['tests','tests.*']):" -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	"${PYTHON}" -m tests || die "Tests failed"
}

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && local EXAMPLES=( examples/. )
	distutils-r1_python_install_all
}
