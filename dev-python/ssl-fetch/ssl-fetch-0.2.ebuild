# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="5"

PYTHON_COMPAT=( python2_7 pypy )

inherit distutils-r1

DESCRIPTION="A small convenience library for fetching files securely"
HOMEPAGE="https://github.com/dol-sen/ssl-fetch"
SRC_URI="https://dev.gentoo.org/~dolsen/releases/ssl-fetch/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
IUSE=""

KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sparc x86"

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
	elog
	elog "This is beta software."
	elog "The APIs it installs should be considered unstable"
	elog "and are subject to change in these early versions."
	elog
	elog "Please file any enhancement requests, or bugs"
	elog "at https://github.com/dol-sen/ssl-fetch/issues"
	elog "I am also on IRC @ #gentoo-portage, #gentoo-keys,... of the freenode network"
	elog
}
