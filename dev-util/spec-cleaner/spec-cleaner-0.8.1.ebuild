# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_4,3_5} )
EGIT_REPO_URI="https://github.com/openSUSE/spec-cleaner.git"
inherit distutils-r1
[[ ${PV} == 9999 ]] && inherit git-r3

DESCRIPTION="SUSE spec file cleaner and formatter"
HOMEPAGE="https://github.com/openSUSE/spec-cleaner"
[[ ${PV} != 9999 ]] && SRC_URI="https://github.com/openSUSE/${PN}/archive/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
[[ ${PV} != 9999 ]] && \
KEYWORDS="~amd64 ~x86"
IUSE="test"

DEPEND="
	test? (
		dev-python/mock[${PYTHON_USEDEP}]
		dev-python/nose[${PYTHON_USEDEP}]
	)
"
RDEPEND="
	${PYTHON_DEPS}
"

[[ ${PV} != 9999 ]] && S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	# we have libexec
	sed -i \
		-e 's:lib/obs:libexec/obs:g' \
		setup.py || die
	distutils-r1_src_prepare
}

python_test() {
	nosetests
}
