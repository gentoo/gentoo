# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE='xml(+)'

inherit distutils-r1

MY_P=${PN}3-${PV}
DESCRIPTION="Web-application vulnerability scanner"
HOMEPAGE="http://wapiti.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="kerberos ntlm"

RDEPEND="dev-python/beautifulsoup4[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/mako[${PYTHON_USEDEP}]
	>=dev-python/requests-1.2.3[${PYTHON_USEDEP}]
	dev-python/tld[${PYTHON_USEDEP}]
	dev-python/yaswfp[${PYTHON_USEDEP}]
	kerberos? ( dev-python/requests-kerberos[${PYTHON_USEDEP}] )
	ntlm? ( dev-python/requests-ntlm[${PYTHON_USEDEP}] )"

distutils_enable_tests --install pytest
BDEPEND+=" test? ( dev-python/responses[${PYTHON_USEDEP}] )"
# Many tests require execution of local test php server
RESTRICT="test"

S=${WORKDIR}/${MY_P}

python_prepare_all() {
	sed -e 's/"pytest-runner"//' \
		-e "/find_packages/s/()/(exclude=['tests*'])/" \
		-e "/DOC_DIR =/s/wapiti/${PF}/" \
		-i setup.py || die
	distutils-r1_python_prepare_all
}
