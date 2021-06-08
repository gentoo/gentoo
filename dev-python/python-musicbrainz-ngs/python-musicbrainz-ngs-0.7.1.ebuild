# Copyright 2019-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..10} pypy3 )

inherit distutils-r1

MY_PN="${PN/%-ngs/ngs}"

DESCRIPTION="Python bindings for the MusicBrainz NGS and the Cover Art Archive webservices"
HOMEPAGE="https://github.com/alastair/python-musicbrainzngs"
SRC_URI="https://github.com/alastair/${MY_PN}/archive/v${PV}.tar.gz -> ${MY_PN}${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD-2 ISC"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

distutils_enable_sphinx docs
distutils_enable_tests setup.py

python_prepare_all() {
	# Prevent un-needed d'loading
	sed -e "s/^ *'sphinx.ext.intersphinx'//" -i docs/conf.py || die
	distutils-r1_python_prepare_all
}

python_install_all() {
	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi

	distutils-r1_python_install_all
}
