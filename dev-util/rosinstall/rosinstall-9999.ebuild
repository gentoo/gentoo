# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..10} )
DISTUTILS_IN_SOURCE_BUILD="yes"
inherit distutils-r1

DESCRIPTION="Command-line tools for maintaining a workspace of projects for ROS"
HOMEPAGE="https://wiki.ros.org/rosinstall https://wiki.ros.org/roslocate"

if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/vcstools/rosinstall"
else
	SRC_URI="http://download.ros.org/downloads/${PN}/${P}.tar.gz
		https://github.com/vcstools/rosinstall/archive/${PV}.tar.gz -> ${P}.tar.gz
	"
	KEYWORDS="~amd64 ~arm"
fi

LICENSE="BSD"
SLOT="0"

RDEPEND="
	dev-python/catkin_pkg[${PYTHON_USEDEP}]
	>=dev-python/vcstools-0.1.38[${PYTHON_USEDEP}]
	dev-python/rosdistro[${PYTHON_USEDEP}]
	>=dev-util/wstool-0.1.12[${PYTHON_USEDEP}]
	dev-python/pyyaml[${PYTHON_USEDEP}]"
BDEPEND="${RDEPEND}
	test? (
		dev-vcs/git
		dev-vcs/bzr
		dev-vcs/mercurial
		app-shells/zsh
	)
"

distutils_enable_tests nose

src_test() {
	# From travis.yml
	# Set git config to silence some stuff in the tests
	git config --global user.email "foo@example.com" || die
	git config --global user.name "Foo Bar" || die
	# Set the hg user
	echo -e "[ui]\nusername = Your Name <your@mail.com>" >> ~/.hgrc || die
	# Set the bzr user
	bzr whoami "Your Name <name@example.com>" || die
	# command to run tests
	# Local tests work even if ros.org is down
	local -x ROSINSTALL_SKIP_PYTHON3=1

	distutils-r1_src_test
}
