# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( pypy3 python3_{7..9} )

inherit toolchain-funcs flag-o-matic distutils-r1

DESCRIPTION="A data templating language for app and tool developers"
HOMEPAGE="https://jsonnet.org/"
SRC_URI="https://github.com/google/jsonnet/archive/v${PV}.tar.gz -> ${P}.tar.gz"
IUSE="custom-optimization doc examples python"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 x86"
DEPEND="
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="
	python? ( ${PYTHON_DEPS} )
"
BDEPEND="
	python? (
		${PYTHON_DEPS}
		dev-python/setuptools[${PYTHON_USEDEP}]
	)
"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

PATCHES=(
	"${FILESDIR}/jsonnet-0.14.0-makefile.patch"
	"${FILESDIR}/jsonnet-0.12.1-dont-call-make-from-setuppy.patch"
	"${FILESDIR}/jsonnet-0.16.0-libdir.patch"
	"${FILESDIR}/jsonnet-0.16.0-cp-var.patch"
)

distutils_enable_tests setup.py

src_prepare() {
	default
	use python && distutils-r1_src_prepare
}

src_configure() {
	use custom-optimization || replace-flags '-O*' -O3
	tc-export CC CXX
	default
}

src_compile() {
	emake bins libs
	use python && distutils-r1_src_compile
}

src_test() {
	emake test
	use python && distutils-r1_src_test
}

src_install() {
	emake PREFIX="${EPREFIX}/usr" DESTDIR="${D}" \
		CP="cp -d" LIBDIR="$(get_libdir)" install
	use python && distutils-r1_src_install
	if use doc; then
		find doc -name '.gitignore' -delete || die
		docinto html
		dodoc -r doc/.
	fi
	if use examples; then
		docinto examples
		dodoc -r examples/.
	fi
}
