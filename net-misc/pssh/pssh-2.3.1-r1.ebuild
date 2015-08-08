# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
DISTUTILS_SINGLE_IMPL=1

inherit distutils-r1

DESCRIPTION="PSSH provides parallel versions of OpenSSH and related tools"
HOMEPAGE="http://code.google.com/p/parallel-ssh/"
SRC_URI="http://parallel-ssh.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~x86-interix ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="net-misc/openssh
	!net-misc/putty"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

# Requires ssh access to run.
RESTRICT="test"

pkg_setup() {
	python-single-r1_pkg_setup
}

python_prepare_all() {
	sed -i -e "s|man/man1'|share/&|g" setup.py || die
	distutils-r1_python_prepare_all
}
