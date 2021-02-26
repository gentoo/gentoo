# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="The Open Fabrics Interfaces (OFI) framework"
HOMEPAGE="http://libfabric.org/ https://github.com/ofiwg/libfabric"
SRC_URI="https://github.com/ofiwg/${PN}/releases/download/v${PV}/${P}.tar.bz2"

LICENSE="BSD GPL-2"
SLOT="0/1"
KEYWORDS="~amd64"
IUSE="cuda efa usnic rocr verbs"

DEPEND="
	rocr? ( dev-libs/rocr-runtime:= )
	usnic? ( dev-libs/libnl:= )
	verbs? ( sys-fabric/libibverbs:= )
"
RDEPEND="
	${DEPEND}
	cuda? ( dev-util/nvidia-cuda-sdk )
"
BDEPEND="
	virtual/pkgconfig
"

DOCS=(
	AUTHORS
	#CONTRIBUTORS
	NEWS.md
	README
	#README.md
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--disable-static
		# let's try to avoid automagic deps
		--enable-bgq=no
		--enable-cuda-dlopen=$(usex cuda yes no)
		--enable-efa=$(usex efa yes no)
		--enable-gni=no
		#--enable-gdrcopy-dlopen=no
		--enable-mrail=yes
		--enable-perf=no
		# no psm libraries packaged that I can find (patches accepted)
		--enable-psm=no
		--enable-psm2=no
		#--enable-psm3=no
		--enable-rocr-dlopen=$(usex rocr yes no)
		--enable-rstream=yes
		--enable-rxd=yes
		--enable-rxm=yes
		--enable-sockets=yes
		--enable-shm=yes
		--enable-tcp=yes
		--enable-udp=yes
		--enable-usnic=$(usex usnic yes no)
		--enable-verbs=$(usex verbs yes no)
		--enable-xpmem=no
	)
	econf "${myeconfargs[@]}"
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
