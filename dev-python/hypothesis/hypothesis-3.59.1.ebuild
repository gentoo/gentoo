# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{5,6,7} pypy{,3} )
PYTHON_REQ_USE="threads(+),sqlite"

inherit distutils-r1 eutils

DESCRIPTION="A library for property based testing"
HOMEPAGE="https://github.com/HypothesisWorks/hypothesis https://pypi.org/project/hypothesis/"
SRC_URI="https://github.com/HypothesisWorks/${PN}/archive/${PN}-python-${PV}.tar.gz"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~m68k ~mips ppc ppc64 s390 ~sh sparc x86"
IUSE=""

RDEPEND="
	dev-python/attrs[${PYTHON_USEDEP}]
	dev-python/coverage[${PYTHON_USEDEP}]
	$(python_gen_cond_dep 'dev-python/enum34[${PYTHON_USEDEP}]' 'python2*' pypy)"

DEPEND="
	${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

S="${WORKDIR}/${PN}-${PN}-python-${PV}/${PN}-python"

pkg_postinst() {
	optfeature "datetime support" dev-python/pytz
	optfeature "dateutil support" dev-python/python-dateutil
	optfeature "numpy support" dev-python/numpy
	optfeature "django support" dev-python/django dev-python/pytz
	optfeature "pytest support" dev-python/pytest
}
