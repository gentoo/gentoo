# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/eyeD3/eyeD3-0.7.5.ebuild,v 1.10 2015/07/16 19:36:40 zlogene Exp $

EAPI=5

# For python3_{2,3}, see bugs 501338, 501340

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Module for manipulating ID3 (v1 + v2) tags in Python"
HOMEPAGE="http://eyed3.nicfit.net/"
SRC_URI="http://eyed3.nicfit.net/releases/${P}.tgz"

LICENSE="GPL-2"
SLOT="0.7"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x64-macos ~x86-macos ~x86-solaris"
IUSE=""

RDEPEND="!<${CATEGORY}/${PN}-0.6.18-r1:0"
DEPEND="${RDEPEND}
	dev-python/paver[${PYTHON_USEDEP}]"

python_prepare_all() {
	# prevent the build system from installing unwrapped bash script
	# and prevent it from pulling optional python-magic
	sed -i -e '/scripts/d' \
		-e '/install_requires/d' pavement.py || die

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install

	sed -e "s:python:${EPYTHON}:" bin/eyeD3 > "${TMPDIR}"/eyeD3 || die
	python_doexe "${TMPDIR}"/eyeD3
}
