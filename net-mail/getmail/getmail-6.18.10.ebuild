# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_SINGLE_IMPL=1
DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )
PYTHON_REQ_USE="ssl"
inherit distutils-r1

DESCRIPTION="A mail retriever with reliable Maildir and mbox delivery"
HOMEPAGE="https://www.getmail6.org/ https://github.com/getmail6/getmail6"
SRC_URI="https://github.com/getmail6/getmail6/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"
S="${WORKDIR}/getmail6-${PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

python_prepare_all() {
	# Use gentoo version number (including revision) for doc dir and remove COPYING file
	sed -i -e "s,'getmail-%s' % __version__,'${PF}'," \
		-e "/docs\/COPYING/d" "${S}"/setup.py || die

	distutils-r1_python_prepare_all
}
