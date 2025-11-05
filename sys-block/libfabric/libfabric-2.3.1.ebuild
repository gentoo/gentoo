# Copyright 2022-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="The Open Fabrics Interfaces (OFI) framework"
HOMEPAGE="http://libfabric.org/ https://github.com/ofiwg/libfabric"

LICENSE="BSD GPL-2"

SRC_URI="https://github.com/ofiwg/${PN}/releases/download/v${PV}/${P}.tar.bz2"
KEYWORDS="~amd64"

# SONAME
SLOT="0/1"
IUSE="cuda efa usnic rocm verbs ucx"

DEPEND="
	rocm? ( dev-libs/rocr-runtime:= )
	usnic? ( dev-libs/libnl:= )
	verbs? ( sys-cluster/rdma-core )
"
RDEPEND="
	${DEPEND}
	cuda? ( dev-util/nvidia-cuda-toolkit )
	ucx? ( sys-cluster/ucx )
"
BDEPEND="
	virtual/pkgconfig
"

DOCS=(
	AUTHORS
	NEWS.md
	README
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		# let's try to avoid automagic deps
		--enable-cuda-dlopen="$(usex cuda)"
		--enable-efa="$(usex efa)"
		--enable-cxi=no
		--enable-gdrcopy-dlopen=no
		--enable-mrail=yes
		--enable-perf=no
		# no psm libraries packaged that I can find (patches accepted)
		--enable-psm2=no
		--enable-psm3=no
		--enable-rocr-dlopen="$(usex rocm)"
		--enable-rxd=yes
		--enable-rxm=yes
		--enable-sockets=yes
		--enable-shm=yes
		--enable-sm2=yes
		--enable-ucx="$(usex ucx)"
		--enable-lpp=yes
		--enable-trace=yes
		--enable-profile=yes
		--enable-monitor=yes
		--enable-hook_hmem=no
		--enable-dmabuf_peer_mem=no
		--enable-lnx=yes
		--enable-opx=no
		--enable-lnx=yes
		--enable-tcp=yes
		--enable-udp=yes
		--enable-usnic="$(usex usnic)"
		--enable-verbs="$(usex verbs)"
		--enable-xpmem=no
		"$(use_with cuda cuda "${CUDA_PATH:-${ESYSROOT}/opt/cuda}")"
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
