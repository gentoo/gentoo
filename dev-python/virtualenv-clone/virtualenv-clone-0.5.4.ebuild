# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8,9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="A script for cloning a non-relocatable virtualenv"
HOMEPAGE="https://github.com/edwardgeorge/virtualenv-clone"
SRC_URI="https://github.com/edwardgeorge/virtualenv-clone/archive/8a61552d99087c99895a0d0ca104ed47a1eade24.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-8a61552d99087c99895a0d0ca104ed47a1eade24"
#no release available: using corresponding commit id

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"

distutils_enable_tests pytest

BDEPEND+="
	test? ( dev-python/virtualenv[${PYTHON_USEDEP}] )
"
