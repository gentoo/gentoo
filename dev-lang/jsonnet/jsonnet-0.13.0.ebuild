# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python3_6 python3_7 )

inherit toolchain-funcs distutils-r1

DESCRIPTION="A data templating language for app and tool developers "
HOMEPAGE="https://jsonnet.org/"
SRC_URI="https://github.com/google/jsonnet/archive/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE="python"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
DEPEND="python? ( ${PYTHON_DEPS} )"
RDEPEND="python? ( ${PYTHON_DEPS} )"
BDEPEND="python? ( ${PYTHON_DEPS}
		dev-python/setuptools[${PYTHON_USEDEP}]
	)"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}/jsonnet-0.12.1-makefile.patch"
	"${FILESDIR}/jsonnet-0.12.1-dont-call-make-from-setuppy.patch"
	"${FILESDIR}/jsonnet-0.13.0-glibc-2.29.patch"
)

src_prepare() {
	default
	use python && distutils-r1_src_prepare
}

src_compile() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" \
		jsonnet \
		libjsonnet.so \
		libjsonnet++.so

	use python && distutils-r1_src_compile
}

src_test() {
	emake CC="$(tc-getCC)" CXX="$(tc-getCXX)" test
	use python && distutils-r1_src_test
}

python_test() {
	esetup.py test || die
}

src_install() {
	dolib.so libjsonnet*.so
	dobin jsonnet

	use python && distutils-r1_src_install
}
