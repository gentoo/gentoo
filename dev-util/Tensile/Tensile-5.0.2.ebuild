# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 prefix

DESCRIPTION="Stretching GPU performance for GEMMs and tensor contractions"
HOMEPAGE="https://github.com/ROCmSoftwarePlatform/Tensile"
SRC_URI="https://github.com/ROCmSoftwarePlatform/Tensile/archive/rocm-${PV}.tar.gz -> rocm-Tensile-${PV}.tar.gz
		https://github.com/littlewu2508/littlewu2508.github.io/raw/main/gentoo-distfiles/${P}-PR1419.patch.gz"
S="${WORKDIR}/${PN}-rocm-${PV}"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0/$(ver_cut 1-2)"

# Not compatible with recent versions of pytest
RESTRICT="test"

RDEPEND="${PYTHON_DEPS}
	dev-python/pyyaml[${PYTHON_USEDEP}]
	dev-python/msgpack[${PYTHON_USEDEP}]
	>=dev-util/rocm-smi-4.3.0
"
DEPEND="${RDEPEND}
	dev-util/hip:${SLOT}
"

PATCHES=( "${FILESDIR}"/${PN}-4.3.0-output-commands.patch
		  "${FILESDIR}"/${PN}-5.0.2-gfx1031.patch
		  "${FILESDIR}"/${PN}-5.0.2-fix-arch-parse.patch
		  "${FILESDIR}"/${PN}-5.0.2-use-ninja.patch
		  "${WORKDIR}"/${PN}-5.0.2-PR1419.patch
	  )

CMAKE_USE_DIR="${WORKDIR}/Source"

src_prepare() {
	distutils-r1_src_prepare
	eapply $(prefixify_ro "${FILESDIR}"/${PN}-5.0.2-gentoopath.patch)

	pushd ${PN} || die

	sed -e "/ROCM_SMI_ROOT/s,lib,$(get_libdir)," \
		-i Source/cmake/FindROCmSMI.cmake || die
	sed -r -e "/TENSILE_USE_LLVM/s/ON/OFF/" \
		-i Source/CMakeLists.txt || die
	sed -e "/chmod 755/d" -i Source/TensileCreateLibrary.cmake || die # remove chmod 755 on
	sed -e "s,\${Tensile_ROOT}/bin/,,g" -i Source/TensileCreateLibrary.cmake cmake/TensileConfig.cmake || die # ${Tensile_ROOT}/bin does not exists; call command directly

	local Tensile_share_dir="\"${EPREFIX}/usr/share/${PN}\""
	sed -e "/HipClangVersion/s/0,0,0/$(hipconfig -v)/" -i Common.py || die

	sed -e "s,os.path.dirname(os.path.realpath(__file__)),${Tensile_share_dir},g" -i ReplacementKernels.py Common.py ${PN}.py || die

	sed -e "s|os\.path\.dirname.*$|\"${EPREFIX}/usr/share/Tensile/Source\", end='')|" -i __init__.py || die

	popd || die

	sed -e "/package_data/d" -e "/data_files/d" -i setup.py || die
}

python_install() {
	distutils-r1_python_install

	python_moduleinto Tensile
	pushd Tensile
	python_domodule Components
	python_newexe Utilities/merge.py ${PN}-merge
}

src_install() {
	distutils-r1_src_install

	pushd ${PN} || die
	insinto /usr/share/${PN}
	doins -r Configs Perf ReplacementKernels ReplacementKernels-cov3 Source CustomKernels
	insinto /usr/$(get_libdir)/cmake/${PN}
	doins cmake/*.cmake
}
