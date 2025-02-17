# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="xml(+)"
DISTUTILS_USE_PEP517=setuptools

inherit distutils-r1 prefix

DESCRIPTION="Collection of Gentoo-specific tools for Java"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"
SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~sparc ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

python_prepare_all() {
	hprefixify src/py/buildparser src/py/findclass setup.py

	# Install the man page manually
	sed -i '/data_files =/ d' setup.py || die

	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install

	# The java eclasses expect the scripts to be in a special location
	python_scriptinto /usr/libexec/${PN}
	python_doexe "${D}$(python_get_scriptdir)"/*
}

python_install_all() {
	doman src/man/*
	distutils-r1_python_install_all
}
