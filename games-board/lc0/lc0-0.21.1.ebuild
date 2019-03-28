# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic meson toolchain-funcs unpacker

MY_MKL_PV="10.0.5.025"

DESCRIPTION="UCI-compliant chess engine designed to play chess via neural network"
HOMEPAGE="https://lczero.org/"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="~amd64"
IUSE="amd-gpupro-opencl amd-opencl +blas-ext blas-int mkl nvidia-cudnn nvidia-opencl switch"
REQUIRED_USE="?? ( amd-gpupro-opencl amd-opencl )
	      ?? ( blas-ext blas-int )
	      || ( amd-gpupro-opencl amd-opencl blas-ext blas-int mkl nvidia-cudnn nvidia-opencl )
	      amd-gpupro-opencl? ( !nvidia-cudnn !nvidia-opencl )
	      amd-opencl? ( !nvidia-cudnn !nvidia-opencl )"

# Build needs extra submodule.
MY_MODULE_N="proto"
MY_MODULE_URI="https://github.com/LeelaChessZero/lczero-common/archive/master.tar.gz"

# We need network weight for runtime.
MY_W_ID="50778"
MY_W_N="weights"
MY_W_SHA="5b535e00f1828556b9199ce7d4dbdbbf91cc8c2f9084d991f9f4ec7d43baa6e5"
MY_W_URI="https://lczero.org/get_network?sha=${MY_W_SHA}"

# We need openblas-dev libraries if we don't have internally.
MY_BLAS_BASE_N="libopenblas-base"
MY_BLAS_DEV_N="libopenblas-dev"
MY_BLAS_PV="0.3.5"
MY_BLAS_SRC="http://archive.ubuntu.com/ubuntu/pool/universe/o/openblas"
MY_BLAS_BASE_URI="${MY_BLAS_SRC}/${MY_BLAS_BASE_N}_${MY_BLAS_PV}+ds-2_amd64.deb"
MY_BLAS_DEV_URI="${MY_BLAS_SRC}/${MY_BLAS_DEV_N}_${MY_BLAS_PV}+ds-2_amd64.deb"

SRC_URI="https://github.com/LeelaChessZero/lc0/archive/v${PV}.tar.gz -> ${P}.tar.gz
	${MY_MODULE_URI} -> ${P}-${MY_MODULE_N}.tar.gz
	${MY_W_URI} -> ${P}-${MY_W_N}_${MY_W_ID}.pb.gz
	blas-ext? ( ${MY_BLAS_BASE_URI} -> ${P}-${MY_BLAS_BASE_N}-${MY_BLAS_PV}.deb
		    ${MY_BLAS_DEV_URI} -> ${P}-${MY_BLAS_DEV_N}-${MY_BLAS_PV}.deb
	)"

DEPEND="
	dev-libs/protobuf:0=
	amd-opencl?    ( !switch? ( >=dev-libs/amdgpu-pro-opencl-18.20.684755
				    x11-drivers/xf86-video-amdgpu ) )
	mkl?           ( !switch? ( >=sci-libs/mkl-10.0.5.025 ) )
	nvidia-cudnn?  ( !switch? ( >=dev-libs/cudnn-7.5.0.56 ) )
	nvidia-opencl? ( !switch? ( >=dev-util/nvidia-cuda-toolkit-10.1.105 ) )"

RDEPEND="${DEPEND}"

BDEPEND="
	dev-cpp/gtest
	dev-util/meson
	virtual/pkgconfig"

BUILD_DIR="${S}/build/release"
DOCS=( README.md CONTRIBUTING.md COPYING )

src_unpack() {
	default

	if use blas-ext; then
	   unpack_deb ${P}-${MY_BLAS_BASE_N}-${MY_BLAS_PV}.deb
	   unpack_deb ${P}-${MY_BLAS_DEV_N}-${MY_BLAS_PV}.deb
	fi
}

src_prepare() {
	default

	# We need to place submodule for build.
	cp -r \
	   "${WORKDIR}"/lczero-common-master/* \
	   "${S}"/libs/lczero-common/ || die "couldn't import proto module"

	# Fix build issue for 0.21.1
	sed -i "s*usr/local*usr*g" "$S"/meson_options.txt || die "couldn't set FHS/Gentoo paths"

	if use blas-int; then
	   # Fix openblas library name for science overlay.
	   eapply "${FILESDIR}/${P}-science.overlay.patch"

	   # Fix openblas internal library paths.
	   sed \
              -e "s*'/usr/lib/'*'/usr/lib/','/usr/lib64/'*g" \
              -i "$S"/meson_options.txt || die "couldn't set openblas lib paths"
	fi

	# Prepare to compile with !static! openblas libraries on the fly.
	# Meson always picks shared if they are in same directory.
	if use blas-ext; then
	   rm -rf \
	         "${WORKDIR}"/usr/lib/x86_64-linux-gnu/libopenblasp-r0.3.5.so \
	         "${WORKDIR}"/usr/lib/x86_64-linux-gnu/libopenblas.so* || die "couldn't remove shared libraries"

	   # Fix openblas paths for compiling on the fly.
	   sed \
	      -e "s*'/usr/lib/'*'${WORKDIR}/usr/lib/x86_64-linux-gnu/'*g" \
	      -e "s*'/usr/include/openblas/'*'${WORKDIR}/usr/include/x86_64-linux-gnu/'*g" \
	      -i "$S"/meson_options.txt || die "couldn't set openblas lib paths"

	   # Fix cblas header name.
	   pushd "${WORKDIR}"/usr/include/x86_64-linux-gnu/ >/dev/null
	   mv cblas-openblas.h cblas.h || die
	   popd >/dev/null
	fi

	# Fix opencl library path for AMD.
	if use amd-opencl; then
	   sed \
	      -e  "s*'/opt/cuda/lib64/', '/usr/local/cuda/lib64/'*'/usr/lib64/'*g" \
	      -i "$S"/meson_options.txt || die "couldn't set amd-opencl lib path"
	fi

	# Fix opencl library path for AMDGPU-PRO.
	if use amd-gpupro-opencl; then
	   sed \
	      -e  "s*'/opt/cuda/lib64/', '/usr/local/cuda/lib64/'*'/opt/amdgpu-pro/lib/x86_64-linux-gnu/','/opt/amdgpu/lib/x86_64-linux-gnu/'*g" \
	      -i "$S"/meson_options.txt || die "couldn't set amd-gpupro-opencl lib path"
	fi

	# Fix intel-mkl lib & include paths for 10.0.5.025
	if ! use switch; then
	   if use mkl; then
	      # We cannot link with single shared 'mkl_rt' library here.
	      # When mkl bumped to > 10.3 in tree drop this patch & code block.
	      eapply "${FILESDIR}/${P}-mkl.patch"

	      sed \
	         -e "s*'/opt/intel/mkl/include'*'/opt/intel/mkl/${MY_MKL_PV}/include/'*g" \
	         -e "s*'/opt/intel/lib/intel64', '/opt/intel/mkl/lib/intel64', '/opt/intel/mkl/lib'*'/opt/intel/mkl/${MY_MKL_PV}/lib/em64t/'*g" \
	         -i "$S"/meson_options.txt || die "couldn't set intel-mkl lib & include paths"
	   fi
	fi
}

src_configure() {
	local emesonargs=(
		-Dbackend=ninja
		-Dbuild_backends=true
		-Dgtest=true
		-Dtensorflow=false
		$(meson_use mkl mkl)
		$(meson_use nvidia-cudnn cudnn)
	)

	if use blas-ext || use blas-int; then
	   local emesonargs+=(
		 -Dblas=true
	   )
	   else
		 local emesonargs+=(
		       -Dblas=false
		 )
	fi

	if use amd-gpupro-opencl || use amd-opencl || use nvidia-opencl; then
	   local emesonargs+=(
		 -Dopencl=true
	   )
	   else
		 local emesonargs+=(
		       -Dopencl=false
	         )
	fi

	# Fix clang & meson bug.
	if tc-is-clang; then
	   local emesonargs+=(
		-Db_lundef=false
	   )
	fi

	# Fix false-positive warning for 0.21.1
	append-cxxflags -Wno-maybe-uninitialized
	meson_src_configure
}

src_test() {
	meson_src_test
}

src_install() {
	default

	dodir /opt/"${P}" || die
	exeinto /opt/"${P}"
	doexe "${BUILD_DIR}"/lc0 "${BUILD_DIR}"/*_test
	insinto /opt/"${P}"
	doins "${BUILD_DIR}"/liblc0_lib.so
	fperms 0755 /opt/"${P}"/liblc0_lib.so
	insinto /opt/"${P}"
	newins "${DISTDIR}"/${P}-${MY_W_N}_${MY_W_ID}.pb.gz ${MY_W_N}_${MY_W_ID}.pb.gz
	einstalldocs
}

pkg_postinst() {
	elog "----------------------IMPORTANT----------------------------"
	elog "You can get latest weights > https://lczero.org/networks/"
	ewarn "Weights must be in the same place with lc0 binary /opt/lc0"
	elog "You can find strongest network -->"
	elog "https://github.com/LeelaChessZero/lc0/wiki/FAQ"
	elog "-----------------------------------------------------------"
	elog "---------------------PERFORMANCE---------------------------"
	elog "Some tips for backend performance comparison for GPU & CPU"
	elog "-----------------------------------------------------------"
	elog "GPU based calculations > CPU based calculations"
	elog "If you use CPU based calculation, prefer MKL over OpenBLAS"
	elog "If you use GPU based calculation, prefer cudnn over OpenCL"
	elog "Additional tools for extra options can be get from"
	optfeature "Strongest engine in the world" games-board/stockfish
	optfeature "Bob Hyatt's strong chess engine" games-board/crafty
	optfeature "Syzygy endgame tablebases" games-board/tablebase-syzygy
	optfeature "Old but strong chess engine" games-board/fruit
}
