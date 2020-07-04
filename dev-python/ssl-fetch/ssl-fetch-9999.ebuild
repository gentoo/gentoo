# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_USE_SETUPTOOLS=no

EGIT_BRANCH="master"

inherit distutils-r1 git-r3

DESCRIPTION="A small convenience library for fetching files securely"
HOMEPAGE="https://github.com/dol-sen/ssl-fetch"
SRC_URI=""
EGIT_REPO_URI="https://github.com/dol-sen/ssl-fetch.git"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS=""

DEPEND=""

RDEPEND="${DEPEND}
	>=dev-python/requests-1.2.1[${PYTHON_USEDEP}]
	"

pkg_postinst() {
	echo
	elog "This is experimental software."
	elog "The APIs it installs should be considered unstable"
	elog "and are subject to change."
	echo
	elog "Please file any enhancement requests, or bugs"
	elog "at https://github.com/dol-sen/ssl-fetch/issues"
	elog "I am also on IRC @ #gentoo-portage, #gentoo-keys,... of the freenode network"
	echo
}
