# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
PYTHON_COMPAT=( python{2_7,3_4} )

SCM=""
if [ "${PV#9999}" != "${PV}" ] ; then
	SCM="git-r3"
	EGIT_REPO_URI="https://github.com/vcstools/rosinstall"
fi

inherit ${SCM} distutils-r1

DESCRIPTION="Command-line tools for maintaining a workspace of projects for ROS"
HOMEPAGE="http://wiki.ros.org/rosinstall http://wiki.ros.org/roslocate"
if [ "${PV#9999}" != "${PV}" ] ; then
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="http://download.ros.org/downloads/${PN}/${P}.tar.gz
		https://github.com/vcstools/rosinstall/archive/${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"
IUSE="test"

RDEPEND="
	dev-python/catkin_pkg[${PYTHON_USEDEP}]
	>=dev-python/vcstools-0.1.38[${PYTHON_USEDEP}]
	dev-python/rosdistro[${PYTHON_USEDEP}]
	>=dev-util/wstool-0.1.12[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-vcs/git
		dev-vcs/bzr
		dev-vcs/mercurial
		app-shells/zsh
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
	# command to run tests
	# Local tests work even if ros.org is down
	export ROSINSTALL_SKIP_PYTHON3=1
	nosetests test || die
}
