# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit flag-o-matic cmake-multilib

bench_ref="78c746269bb53ff0b2026e7b1a8fe11fabc69e64"
cash_ref="847edfb18afa6b755a91a203872bcd66bbeb5868"
sash_ref="9da5a40793d77e7f6d3afb504cf02c0acb59d35c"
opencl_ref="91ebbda2986f3f32a873d02ca5eb550f26c6b70d"
riac_ref="855e725739b7688290f66f592f858149c92375c5"
nexus_ref="90d42335ff3a2fe67ac4ae41a844f0b245bb123c"

DESCRIPTION="The C++ Actor Framework (CAF)"
HOMEPAGE="https://actor-framework.org/"
SRC_URI="https://github.com/actor-framework/actor-framework/archive/${PV}.tar.gz -> ${P}.tar.gz
	benchmarks? ( https://github.com/actor-framework/benchmarks/archive/${bench_ref}.tar.gz -> CAF_${PV}-benchmarks.tar.gz )
	cash? ( https://github.com/actor-framework/cash/archive/${cash_ref}.tar.gz -> CAF_${PV}-cash.tar.gz
		https://github.com/Neverlord/sash/archive/${sash_ref}.tar.gz -> CAF_${PV}-sash_cash.tar.gz )
	nexus? ( https://github.com/actor-framework/nexus/archive/${nexus_ref}.tar.gz -> CAF_${PV}-nexus.tar.gz )
	opencl? ( https://github.com/actor-framework/opencl/archive/${opencl_ref}.tar.gz -> CAF_${PV}-opencl.tar.gz )
	riac? ( https://github.com/actor-framework/riac/archive/${riac_ref}.tar.gz -> CAF_${PV}-riac.tar.gz )"
LICENSE="|| ( Boost-1.0 BSD )"
SLOT="0/13.2"
KEYWORDS="~amd64 ~x86"
IUSE="boost benchmarks cash debug doc examples +mem_management nexus opencl riac static test"

DEPEND="${RDEPEND}
	doc? ( app-doc/doxygen
		dev-texlive/texlive-latex
		dev-tex/hevea
	)"
RDEPEND="boost? ( dev-libs/boost[${MULTILIB_USEDEP}] )
	net-misc/curl[${MULTILIB_USEDEP}]
	opencl? ( virtual/opencl[${MULTILIB_USEDEP}] )"
REQUIRED_USE="cash? ( riac )"

src_unpack() {
	unpack ${A}
	for i in cash nexus; do
		if use ${i}; then
			mv "${i}"*/* "${S}/${i}/" || die "died copying sources for ${i}"
		fi
	done
	for i in opencl riac; do
		if use ${i}; then
			mv "${i}"*/* "${S}/libcaf_${i}/" || die "died copying sources for ${i}"
		fi
	done
	if use cash; then
		mv sash*/* "${S}/cash/sash/" || die "died copying sources for sash"
	fi
	if use benchmarks; then
		mv "${WORKDIR}/benchmarks-"* "${WORKDIR}/benchmarks" || die "died moving benchmarks"
	fi
}

src_prepare() {
	find "${S}" -name CMakeLists.txt \
		-exec sed -i 's#\(install(.* DESTINATION \)lib#\1${LIBRARY_OUTPUT_PATH}#g' \{\} + \
		|| die
	rm examples/CMakeLists.txt || die
	append-cxxflags "-std=c++11 -pthread -Wextra -Wall -pedantic"
	append-cflags "-std=c11 -pthread -Wextra -Wall -pedantic"

	cmake-utils_src_prepare
}

multilib_src_configure() {
	local mycmakeargs=(
		-DCAF_NO_EXAMPLES=ON
		-DCAF_NO_BENCHMARKS=ON
		-DCAF_USE_ASIO=$(usex boost)
		-DCAF_NO_CASH=$(usex cash OFF ON)
		-DCAF_LOG_LEVEL=$(usex debug 3 0)
		-DCAF_ENABLE_RUNTIME_CHECKS=$(usex debug)
		-DCAF_ENABLE_ADDRESS_SANITIZER=$(usex debug)
		-DCAF_NO_MEM_MANAGEMENT=$(usex mem_management OFF ON)
		-DCAF_NO_NEXUS=$(usex nexus OFF ON)
		-DCAF_NO_OPENCL=$(usex opencl OFF ON)
		-DCAF_NO_RIAC=$(usex riac OFF ON)
		-DCAF_BUILD_STATIC=$(usex static)
		-DCAF_NO_UNIT_TESTS=$(usex test OFF ON )
		-DLIBRARY_OUTPUT_PATH="$(get_libdir)"
	)

	cmake-utils_src_configure
}

multilib_src_compile() {
	cmake-utils_src_compile

	if use doc; then
		emake doc
		emake -C "${S}/manual/build-pdf"
		emake -C "${S}/manual/build-html"
	fi
}

multilib_src_install() {
	DOCS=( README.md )
	use examples && DOCS+=( "${S}/examples" )
	use benchmarks && DOCS+=( "${WORKDIR}/benchmarks/" )
	if use doc; then
		HTML_DOCS=( "${S}/html/"* )
		for i in pdf html; do
			DOCS+=( "${S}"/manual/build-${i}/manual.${i} )
		done
	fi

	cmake-utils_src_install
}
