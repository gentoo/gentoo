# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{8..10} )

inherit distutils-r1

MY_P="${PN}-v${PV}"
DESCRIPTION="URI Template expansion in strict adherence to RFC 6570"
HOMEPAGE="https://gitlab.linss.com/open-source/uri_template/"
SRC_URI="https://gitlab.linss.com/open-source/${PN}/-/archive/v${PV}/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~riscv ~sparc ~x86"

python_test() {
	"${EPYTHON}" "test.py" || die "Tests fail with ${EPYTHON}."
}
