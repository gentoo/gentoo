# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..11} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1 pypi

DESCRIPTION="Tail over HTTP"
HOMEPAGE="https://github.com/vpelletier/htail"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
