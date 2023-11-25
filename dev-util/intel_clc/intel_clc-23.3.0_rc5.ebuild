# Copyright 2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )

inherit llvm meson python-any-r1

MY_PV="${PV/_/-}"

DESCRIPTION="intel_clc tool used for building OpenCL C to SPIR-V"
HOMEPAGE="https://mesa3d.org/"

if [[ ${PV} == 9999 ]]; then
	S="${WORKDIR}/intel_clc-${MY_PV}"
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/mesa.git"
	inherit git-r3
else
	S="${WORKDIR}/mesa-${MY_PV}"
	SRC_URI="https://archive.mesa3d.org/mesa-${MY_PV}.tar.xz"
	KEYWORDS="~amd64"
fi

LICENSE="MIT SGI-B-2.0"
SLOT="0"
IUSE="debug"

RDEPEND="
	dev-libs/libclc
	dev-util/spirv-tools
	>=sys-libs/zlib-1.2.8:=
	x11-libs/libdrm
"
DEPEND="${RDEPEND}
	dev-libs/expat
"
BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep ">=dev-python/mako-0.8.0[\${PYTHON_USEDEP}]")
	virtual/pkgconfig
"

# Please keep the LLVM dependency block separate. Since LLVM is slotted,
# we need to *really* make sure we're not pulling one than more slot
# simultaneously.
#
# How to use it:
# 1. Specify LLVM_MAX_SLOT (inclusive), e.g. 16.
# 2. Specify LLVM_MIN_SLOT (inclusive), e.g. 15.
LLVM_MAX_SLOT="16"
LLVM_MIN_SLOT="15"
PER_SLOT_DEPSTR="
	(
		dev-util/spirv-llvm-translator:@SLOT@
		sys-devel/clang:@SLOT@
		sys-devel/llvm:@SLOT@
	)
"
LLVM_DEPSTR="
	|| (
		$(for ((slot=LLVM_MAX_SLOT; slot>=LLVM_MIN_SLOT; slot--)); do
			echo "${PER_SLOT_DEPSTR//@SLOT@/${slot}}"
		done)
	)
	<sys-devel/clang-$((LLVM_MAX_SLOT + 1)):=
	<sys-devel/llvm-$((LLVM_MAX_SLOT + 1)):=
"
RDEPEND="${RDEPEND}
	${LLVM_DEPSTR}
"
unset LLVM_MIN_SLOT {LLVM,PER_SLOT}_DEPSTR

llvm_check_deps() {
	has_version "dev-util/spirv-llvm-translator:${LLVM_SLOT}" &&
	has_version "sys-devel/clang:${LLVM_SLOT}" &&
	has_version "sys-devel/llvm:${LLVM_SLOT}"
}

python_check_deps() {
	python_has_version -b ">=dev-python/mako-0.8.0[${PYTHON_USEDEP}]"
}

pkg_setup() {
	llvm_pkg_setup
	python-any-r1_pkg_setup
}

src_configure() {
	PKG_CONFIG_PATH="$(get_llvm_prefix "${LLVM_MAX_SLOT}")/$(get_libdir)/pkgconfig"

	local emesonargs=(
		-Dllvm=enabled
		-Dshared-llvm=enabled
		-Dintel-clc=enabled

		-Dgallium-drivers=''
		-Dvulkan-drivers=''

		# Set platforms empty to avoid the default "auto" setting. If
		# platforms is empty meson.build will add surfaceless.
		-Dplatforms=''

		-Dglx=disabled
		-Dzstd=disabled

		--buildtype $(usex debug debug plain)
		-Db_ndebug=$(usex debug false true)
	)
	meson_src_configure
}

src_install() {
	dobin "${BUILD_DIR}"/src/intel/compiler/intel_clc
}
