# Copyright 1999-2024 Gentoo Authors
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
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

python_prepare_all() {
	hprefixify src/py/buildparser src/py/findclass setup.py
	# Install the scripts and the man page manually
	sed -i '/scripts = /,/data_files =/d' setup.py
	distutils-r1_python_prepare_all
}

python_install() {
	distutils-r1_python_install

	python_scriptinto /usr/libexec/${PN}
	local scripts=(
		"src/py/maven-helper.py"
		"src/py/xml-rewrite-3.py"
		"src/py/findclass"
		"src/py/xml-rewrite.py"
		"src/py/xml-rewrite-2.py"
		"src/py/buildparser"
		"src/py/class-version-verify.py"
		"src/py/build-xml-rewrite"
		"src/py/jarjarclean"
		"src/py/eclipse-build.py"
	)
	python_doscript "${scripts[@]}"
}

python_install_all() {
	distutils-r1_python_install_all
	doman src/man/findclass.1
}
