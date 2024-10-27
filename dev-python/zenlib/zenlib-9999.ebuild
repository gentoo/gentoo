# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{11..13} )

inherit distutils-r1 git-r3

DESCRIPTION="Useful python decorators and utilities"
HOMEPAGE="https://github.com/desultory/zenlib/"
EGIT_REPO_URI="https://github.com/desultory/zenlib.git"

LICENSE="GPL-2"
SLOT="0"

distutils_enable_tests unittest

python_test() {
	eunittest tests
}
