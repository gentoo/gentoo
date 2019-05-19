# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="A mastodon CLI client"
HOMEPAGE="https://github.com/ihabunek/toot"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ihabunek/toot"
else
	SRC_URI="https://github.com/ihabunek/toot/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

RESTRICT="!test? ( test )"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/beautifulsoup:4[${PYTHON_USEDEP}]
	dev-python/wcwidth[${PYTHON_USEDEP}]
	>=dev-python/urwid-2.0.1[${PYTHON_USEDEP}]"

DEPEND="${RDEPEND}"

distutils_enable_tests pytest
