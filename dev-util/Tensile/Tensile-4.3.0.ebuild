# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
SRC_URI="https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz"
S="${WORKDIR}/${PN}-rocm-${PV}"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

# Not compatible with recent versions of pytest
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-util/hip:${SLOT}
"
BDEPEND="test? (
	dev-util/rocminfo:${SLOT}
)"

PATCHES=(
	"${FILESDIR}/Tensile-${PV}-hsaco-compile-specified-arch.patch" # backported from upstream, should remove after 4.3.0
	"${FILESDIR}/Tensile-4.3.0-output-commands.patch"
)

CMAKE_USE_DIR="${WORKDIR}/Source"

distutils_enable_tests pytest

src_prepare() {
	distutils-r1_src_prepare

	mv ${PN}/Source "${WORKDIR}"/ || die
	sed -e "/ROCM_SMI_ROOT/s,lib,$(get_libdir)," \
		-i "${WORKDIR}"/Source/cmake/FindROCmSMI.cmake || die
	sed -r -e "/TENSILE_USE_LLVM/s/ON/OFF/" \
		-i "${WORKDIR}"/Source/CMakeLists.txt || die

	sed -e "/HipClangVersion/s/0,0,0/$(ver_rs 1-3 ,)/" \
		-e "/SourcePath/s,os\.path\.join.*$,\"${EPREFIX}/usr/share/${PN}\"," \
		-i ${PN}/Common.py || die

	sed -e "s|os\.path\.dirname.*$|\"${EPREFIX}/usr/share/Tensile\", end='')|" \
		-i ${PN}/__init__.py || die
}

src_test() {
	ROCM_PATH="${EPREFIX}/usr/" distutils-r1_src_test
}

src_install() {
	distutils-r1_src_install

	# Move the cmake files to the correct directory
	mkdir -p "${ED}/usr/$(get_libdir)/cmake/${PN}" || die
	mv "${ED}/usr/cmake/"* "${ED}/usr/$(get_libdir)/cmake/${PN}" || die
	rm -r "${ED}/usr/cmake" || die

	insinto /usr/share/${PN}
	doins -r "${WORKDIR}"/Source/*
	dosym . /usr/share/${PN}/Source
}
