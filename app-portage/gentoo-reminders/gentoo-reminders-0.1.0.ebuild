# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit-core
PYTHON_COMPAT=( python3_{13..15} )

inherit distutils-r1

DESCRIPTION="Generate reminder emails for Gentoo package maintainers"
HOMEPAGE="https://github.com/mattst88/gentoo-reminders/"
SRC_URI="
	https://github.com/mattst88/gentoo-reminders/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-python/jinja2[${PYTHON_USEDEP}]
	dev-util/github-cli
	dev-util/pkgcheck[${PYTHON_USEDEP}]
	dev-vcs/git
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
