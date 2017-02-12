# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
CMAKE_BUILD_TYPE=Release

inherit cmake-utils linux-info python-single-r1

DESCRIPTION="Record and Replay Framework"
HOMEPAGE="http://rr-project.org/"
SRC_URI="https://github.com/mozilla/${PN}/archive/${PV}.tar.gz -> mozilla-${P}.tar.gz"

LICENSE="MIT BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pexpect[${PYTHON_USEDEP}]
		dev-libs/libpfm
		sys-libs/zlib
		${PYTHON_DEPS}"

RDEPEND="
	sys-devel/gdb[xml]
	${DEPEND}"

pkg_setup() {
	if use kernel_linux; then
		CONFIG_CHECK="SECCOMP"
		linux-info_pkg_setup
	fi
	python-single-r1_pkg_setup
}
