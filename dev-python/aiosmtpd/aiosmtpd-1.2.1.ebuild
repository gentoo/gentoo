# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_USE_SETUPTOOLS=rdepend

inherit distutils-r1

DESCRIPTION="asyncio based SMTP server"
HOMEPAGE="https://aiosmtpd.readthedocs.io/en/latest/"
SRC_URI="https://github.com/aio-libs/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
PATCHES=(
	"${FILESDIR}/${P}-skip-test-expired-certificate.patch" )

RDEPEND="dev-python/atpublic[${PYTHON_USEDEP}]"

distutils_enable_tests nose

src_prepare() {
	rm -r examples || die
	distutils-r1_python_prepare_all
}
