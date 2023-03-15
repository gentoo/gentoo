# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Interact with Mattermost incoming webhooks easily"
HOMEPAGE="https://github.com/numberly/matterhook"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-python/requests[${PYTHON_USEDEP}]"
