# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cuda eutils flag-o-matic portability toolchain-funcs unpacker versionator

MYD=$(get_version_component_range 1-2)
DRIVER_PV="375.26"

DESCRIPTION="NVIDIA CUDA Software Development Kit"
HOMEPAGE="https://developer.nvidia.com/cuda-zone"
SRC_URI="https://developer.nvidia.com/compute/cuda/${MYD}/Prod2/local_installers/cuda_${PV}_${DRIVER_PV}_linux-run -> cuda_${PV}_${DRIVER_PV}_linux.run"

LICENSE="CUDPP"
SLOT="0"
KEYWORDS="~amd64 ~amd64-linux"
IUSE="+cuda debug +doc +examples opencl mpi"

RDEPEND="
	~dev-util/nvidia-cuda-toolkit-${PV}
	media-libs/freeglut
	examples? (
		media-libs/freeimage
		media-libs/glew:0=
		>=x11-drivers/nvidia-drivers-375.26[uvm]
		mpi? ( virtual/mpi )
		)"
DEPEND="${RDEPEND}"

RESTRICT="test"

S=${WORKDIR}/samples

QA_EXECSTACK=(
	opt/cuda/sdk/0_Simple/cdpSimplePrint/cdpSimplePrint
	opt/cuda/sdk/0_Simple/cdpSimpleQuicksort/cdpSimpleQuicksort
	opt/cuda/sdk/bin/x86_64/linux/release/cdpSimplePrint
	opt/cuda/sdk/bin/x86_64/linux/release/cdpSimpleQuicksort
	)

src_unpack() {
	# We first need to unpack the cuda_${PV}_linux.run file
	# which includes the cuda-samples*run file.
	unpacker
	unpacker run_files/cuda-samples*run
}

pkg_setup() {
	if use cuda || use opencl; then
		cuda_pkg_setup
	fi
}

src_prepare() {
	export RAWLDFLAGS="$(raw-ldflags)"
#	epatch "${FILESDIR}"/${P}-asneeded.patch

	local file
	while IFS="" read -d $'\0' -r file; do
		sed \
			-e 's:-O[23]::g' \
			-e "/LINK/s:gcc:$(tc-getCC) ${LDFLAGS}:g" \
			-e "/LINK/s:g++:$(tc-getCXX) ${LDFLAGS}:g" \
			-e "/CC/s:gcc:$(tc-getCC):g" \
			-e "/GCC/s:g++:$(tc-getCXX):g" \
			-e "/NVCC /s|\(:=\).*|:= ${EPREFIX}/opt/cuda/bin/nvcc|g" \
			-e "/ CFLAGS/s|\(:=\)|\1 ${CFLAGS}|g" \
			-e "/ CXXFLAGS/s|\(:=\)|\1 ${CXXFLAGS}|g" \
			-e "/NVCCFLAGS/s|\(:=\)|\1 ${NVCCFLAGS} |g" \
			-e 's:-Wimplicit::g' \
			-e "s|../../common/lib/linux/\$(OS_ARCH)/libGLEW.a|$($(tc-getPKG_CONFIG) --libs glew)|g" \
			-e "s|../../common/lib/\$(OSLOWER)/libGLEW.a|$($(tc-getPKG_CONFIG) --libs glew)|g" \
			-e "s|../../common/lib/\$(OSLOWER)/\$(OS_ARCH)/libGLEW.a|$($(tc-getPKG_CONFIG) --libs glew)|g" \
			-i "${file}" || die
			# -e "/ALL_LDFLAGS/s|:=|:= ${RAWLDFLAGS} |g" \
	done < <(find . -type f -name 'Makefile' -print0)

	rm -rf common/inc/GL || die
	find . -type f -name '*.a' -delete || die

	eapply_user
}

src_compile() {
	use examples || return
	local myopts=("verbose=1")
	use debug && myopts+=("dbg=1")
	export FAKEROOTKEY=1 # Workaround sandbox issue in #462602
	emake \
		cuda-install="${EPREFIX}/opt/cuda" \
		CUDA_PATH="${EPREFIX}/opt/cuda/" \
		MPI_GCC=10 \
		"${myopts[@]}"
}

src_test() {
	addwrite /dev/nvidiactl
	addwrite /dev/nvidia0

	local i
	for i in {0..9}*/*; do
		emake -C "${i}" run
	done
}

src_install() {
	local f t crap=( *.txt Samples.htm* )

	if use doc; then
		ebegin "Installing docs ..."
			while IFS="" read -d $'\0' -r f; do
				treecopy "${f}" "${ED%/}"/usr/share/doc/${PF}/
			done < <(find -type f \( -name 'readme.txt' -o -name '*.pdf' \) -print0)

			while IFS="" read -d $'\0' -r f; do
				docompress -x "${f#${ED%/}}"
			done < <(find "${ED%/}"/usr/share/doc/${PF}/ -type f -name 'readme.txt' -print0)
		eend
	fi

	ebegin "Cleaning before installation..."
		for f in "${crap[@]}"; do
			rm -f "${f}" || die
		done
		find -type f \( -name '*.o' -o -name '*.pdf' -o -name 'readme.txt' \) -delete || die
	eend

	ebegin "Moving files..."
		while IFS="" read -d $'\0' -r f; do
			t="$(dirname ${f})"
			if [[ ${t/obj\/} != ${t} || ${t##*.} == a ]]; then
				continue
			fi
			if [[ -x ${f} ]]; then
				exeinto /opt/cuda/sdk/"${t}"
				doexe "${f}"
			else
				insinto /opt/cuda/sdk/"${t}"
				doins "${f}"
			fi
		done < <(find . -type f -print0)
	eend
}
