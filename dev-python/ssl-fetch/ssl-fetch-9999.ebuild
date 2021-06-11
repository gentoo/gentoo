# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} pypy3 )
DISTUTILS_USE_SETUPTOOLS=no
inherit distutils-r1 git-r3

DESCRIPTION="Small convenience library for fetching files securely"
HOMEPAGE="https://github.com/dol-sen/ssl-fetch"
EGIT_REPO_URI="https://github.com/dol-sen/ssl-fetch.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

RDEPEND=">=dev-python/requests-1.2.1[${PYTHON_USEDEP}]"

pkg_postinst() {
	elog "This is experimental software."
	elog "The APIs it installs should be considered unstable"
	elog "and are subject to change."
	elog
	elog "Please file any enhancement requests, or bugs"
	elog "at https://github.com/dol-sen/ssl-fetch/issues"
	elog "I am also on IRC @ #gentoo-portage, #gentoo-keys,... of the freenode network"
}
