# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="xml(+)"
DISTUTILS_USE_PEP517=flit

inherit distutils-r1 prefix

DESCRIPTION="Collection of Gentoo-specific tools for Java"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:Java"
SRC_URI="https://gitweb.gentoo.org/proj/${PN}.git/snapshot/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~sparc ~x64-macos ~x64-solaris"

distutils_enable_tests unittest

python_prepare_all() {
	hprefixify src/${PN}/scripts/findclass.py
	distutils-r1_python_prepare_all
}

python_test() {
	eunittest -t src -s test
}

src_install() {
	distutils-r1_src_install

	# The java eclasses expect the scripts to be in a special location
	cd "${ED}"/usr/bin || die
	local script
	for script in *; do
		rm "${script}" || die
		dosym -r /usr/lib/python-exec/python-exec2 "/usr/libexec/${PN}/${script}"
	done
}
