# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/vcstools/vcstools"
fi

inherit ${SCM} distutils-r1

DESCRIPTION="Python library for interacting with various VCS systems"
HOMEPAGE="http://wiki.ros.org/vcstools"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://download.ros.org/downloads/${PN}/${P}.tar.gz
		http://github.com/vcstools/vcstools/archive/${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/python-dateutil[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-vcs/git
		dev-vcs/bzr
		dev-vcs/mercurial
		dev-vcs/subversion
	)
"

python_test() {
	# From travis.yml
	# Set git config to silence some stuff in the tests
	git config --global user.email "foo@example.com"
	git config --global user.name "Foo Bar"
	# Set the hg user
	echo -e "[ui]\nusername = Your Name <your@mail.com>" >> ~/.hgrc
	# Set the bzr user
	bzr whoami "Your Name <name@example.com>"
	#git config --global user.email "you@example.com"
	#git config --global user.name "Your Name"

	nosetests --with-coverage --cover-package vcstools || die
}
