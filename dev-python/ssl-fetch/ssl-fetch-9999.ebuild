# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} pypy3 )

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
	einfo "I am also on IRC @ #gentoo-ci of the Libera.Chat network"
}
