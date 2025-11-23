# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_OPTIONAL=1
DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=meson-python
inherit distutils-r1 meson

DESCRIPTION="C Library for NVM Express on Linux"
HOMEPAGE="https://github.com/linux-nvme/libnvme"
SRC_URI="https://github.com/linux-nvme/libnvme/archive/refs/tags/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0/1"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~loong ~mips ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="dbus examples io-uring +json keyutils python ssl test"
RESTRICT="!test? ( test )"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

DEPEND="
	json? ( dev-libs/json-c:= )
	keyutils? ( sys-apps/keyutils:= )
	dbus? ( sys-apps/dbus:= )
	python? ( ${PYTHON_DEPS} )
	ssl? ( >=dev-libs/openssl-1.1:= )
	io-uring? ( sys-libs/liburing:= )
"
RDEPEND="
	${DEPEND}
"
BDEPEND="
	python? (
		${DISTUTILS_DEPS}
		dev-lang/swig
		dev-python/meson-python[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests unittest

src_prepare() {
	default
	use python && distutils-r1_src_prepare
}

src_configure() {
	local emesonargs=(
		-Dpython=disabled
		$(meson_use test tests)
		$(meson_use examples)
		$(meson_feature json json-c)
		$(meson_feature dbus libdbus)
		$(meson_feature keyutils)
		$(meson_feature ssl openssl)
		$(meson_feature io-uring liburing)
	)
	meson_src_configure
	use python && distutils-r1_src_configure
}

python_compile() {
	local emesonargs=(
		-Dpython=enabled
	)
	meson_src_configure --reconfigure
	distutils-r1_python_compile
}

src_compile() {
	meson_src_compile

	use python && distutils-r1_src_compile
}

src_test() {
	meson_src_test
	use python && distutils-r1_src_test
}

python_test() {
	local -A test_args=(
		["test-nbft.py"]="--filename=${S}/libnvme/tests/NBFT"
	)
	pushd "${BUILD_DIR}" >/dev/null || die
	local testfile
	for testfile in "${S}"/libnvme/tests/*.py; do
		PYTHONPATH="${BUILD_DIR}" "${EPYTHON}" "${testfile}" \
			${test_args[${testfile##*/}]} \
			|| die "test ${testfile##*/} failed with ${EPYTHON}"
	done
	popd >/dev/null || die
}

src_install() {
	meson_src_install
	use python && distutils-r1_src_install
}
