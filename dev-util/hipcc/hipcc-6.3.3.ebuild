# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 19 )
inherit cmake perl-functions llvm-r1

DESCRIPTION="Radeon Open Compute hipcc"
HOMEPAGE="https://github.com/ROCm/llvm-project/tree/amd-staging/amd/hipcc"

MY_P=llvm-project-rocm-${PV}
components=( "amd/hipcc" )
if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/ROCm/llvm-project"
	inherit git-r3
	S="${WORKDIR}/${P}/${components[0]}"
else
	SRC_URI="https://github.com/ROCm/llvm-project/archive/rocm-${PV}.tar.gz -> ${MY_P}.tar.gz"
	S="${WORKDIR}/${MY_P}/${components[0]}"
	KEYWORDS="~amd64"
fi

LICENSE="Apache-2.0 MIT"
SLOT="0/$(ver_cut 1-2)"
IUSE="debug test"
RESTRICT="!test? ( test )"

DEPEND="
	$(llvm_gen_dep '
		llvm-runtimes/compiler-rt:${LLVM_SLOT}=
		llvm-core/llvm:${LLVM_SLOT}=
		llvm-core/clang:${LLVM_SLOT}=
	')
"
RDEPEND="${DEPEND}
	!<dev-util/hip-5.7
"

PATCHES=(
	"${FILESDIR}/${PN}-5.7.1-hipcc-hip-version.patch"
)

src_unpack() {
	if [[ ${PV} == *9999 ]] ; then
		git-r3_fetch
		git-r3_checkout '' . '' "${components[@]}"
	else
		archive="${MY_P}.tar.gz"
		ebegin "Unpacking from ${archive}"
		tar -x -z -o \
			-f "${DISTDIR}/${archive}" \
			"${components[@]/#/${MY_P}/}" || die
		eend ${?}
	fi
}

src_prepare() {
	cmake_src_prepare

	sed -e "s:lib/llvm/bin:lib/llvm/${LLVM_SLOT}/bin:" \
		-e "s:/opt/rocm:/usr:g" \
		-i bin/hipvars.pm \
		-i src/hipBin_base.h \
		-i src/hipBin_amd.h || die

	sed -e "s:\$ENV{'DEVICE_LIB_PATH'}:'${EPREFIX}/usr/lib/amdgcn/bitcode':" \
		-e "s:\$ENV{'HIP_LIB_PATH'}:'${EPREFIX}/usr/$(get_libdir)':" \
		-i bin/hipcc.pl || die

	# With Clang>17 -amdgpu-early-inline-all=true causes OOMs in dependencies
	# https://github.com/llvm/llvm-project/issues/86332
	sed -e "s/-mllvm -amdgpu-early-inline-all=true //g" \
		-i bin/hipcc.pl \
		-i src/hipBin_amd.h || die
}

src_install() {
	cmake_src_install
	# rm unwanted copy
	rm -rf "${ED}/usr/hip" || die
	# Handle hipvars.pm
	rm "${ED}/usr/bin/hipvars.pm" || die
	perl_domodule "${S}"/bin/hipvars.pm
}
