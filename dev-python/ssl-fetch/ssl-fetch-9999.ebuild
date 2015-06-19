# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ssl-fetch/ssl-fetch-9999.ebuild,v 1.6 2015/02/09 02:51:38 mrueg Exp $

EAPI="5"

PYTHON_COMPAT=(python{2_7,3_3,3_4} pypy)

EGIT_BRANCH="master"

inherit distutils-r1 git-2

EGIT_REPO_URI="git://github.com/dol-sen/ssl-fetch.git"

DESCRIPTION="A small convenience library for fetching files securely"
HOMEPAGE="https://github.com/dol-sen/ssl-fetch"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS=""

DEPEND=""

RDEPEND="${DEPEND}
	>=dev-python/requests-1.2.1[${PYTHON_USEDEP}]
	python_targets_python2_7? (
		dev-python/ndg-httpsclient[python_targets_python2_7]
		dev-python/pyasn1[python_targets_python2_7]
		>=dev-python/pyopenssl-0.13[python_targets_python2_7]
		)
	"

pkg_postinst() {
	einfo
	einfo "This is experimental software."
	einfo "The APIs it installs should be considered unstable"
	einfo "and are subject to change."
	einfo
	einfo "Please file any enhancement requests, or bugs"
	einfo "at https://github.com/dol-sen/ssl-fetch/issues"
	einfo "I am also on IRC @ #gentoo-portage, #gentoo-keys,... of the freenode network"
	einfo
}
