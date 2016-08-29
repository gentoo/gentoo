# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_3,3_4} )

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/vcstools/wstool"
fi

inherit ${SCM} distutils-r1

DESCRIPTION="Commands to manage several local SCM repositories for ROS"
HOMEPAGE="http://wiki.ros.org/wstool"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://download.ros.org/downloads/${PN}/${P}.tar.gz
		https://github.com/vcstools/wstool/archive/${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/pyyaml[${PYTHON_USEDEP}]
	>=dev-python/vcstools-0.1.38[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/sphinx
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/coverage[${PYTHON_USEDEP}]
		dev-vcs/git
		dev-vcs/bzr
		dev-vcs/mercurial
		dev-vcs/subversion
	)
"

PATCHES=( "${FILESDIR}/prefix.patch" )
DISTUTILS_IN_SOURCE_BUILD="yes"

python_test() {
	# From travis.yml
	# Set git config to silence some stuff in the tests
	git config --global user.email "foo@example.com"
	git config --global user.name "Foo Bar"
	# Set the hg user
	echo -e "[ui]\nusername = Your Name <your@mail.com>" >> ~/.hgrc
	# Set the bzr user
	bzr whoami "Your Name <name@example.com>"
	# command to run tests
	nosetests --with-coverage --cover-package=wstool || die
}
