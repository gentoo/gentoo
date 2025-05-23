# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{10..13} )
inherit distutils-r1

DESCRIPTION="Execute commands and copy files over SSH to multiple machines at once"
HOMEPAGE="https://github.com/krig/parallax/"
SRC_URI="https://github.com/krig/parallax/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="all-rights-reserved"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~x86"

# Requires SSH connection to hosts for testing
RESTRICT="test"
