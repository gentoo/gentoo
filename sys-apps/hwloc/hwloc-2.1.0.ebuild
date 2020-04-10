# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit autotools cuda flag-o-matic systemd toolchain-funcs multilib-minimal

MY_PV="v$(ver_cut 1-2)"

DESCRIPTION="displays the hardware topology in convenient formats"
HOMEPAGE="http://www.open-mpi.org/projects/hwloc/"
SRC_URI="http://www.open-mpi.org/software/${PN}/${MY_PV}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0/15"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="cairo +cpuid cuda debug gl libudev netloc nvml +pci plugins static-libs svg xml X"

# opencl support dropped with x11-drivers/ati-drivers being removed (#582406).
# Anyone with hardware is welcome to step up and help test to get it re-added.

RDEPEND=">=sys-libs/ncurses-5.9-r3:0[${MULTILIB_USEDEP}]

	cairo?		( >=x11-libs/cairo-1.12.14-r4[X?,svg?,${MULTILIB_USEDEP}] )
	cuda?		( >=dev-util/nvidia-cuda-toolkit-6.5.19-r1:= )
	gl?		( x11-drivers/nvidia-drivers[static-libs,tools] )
	libudev?	( virtual/libudev )
	netloc?		( !sys-apps/netloc )
	pci?		(
				>=sys-apps/pciutils-3.3.0-r2[${MULTILIB_USEDEP}]
				>=x11-libs/libpciaccess-0.13.1-r1[${MULTILIB_USEDEP}]
			)
	plugins?	( dev-libs/libltdl:0[${MULTILIB_USEDEP}] )
	xml?		( >=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}] )"
DEPEND="${RDEPEND}
	>=virtual/pkgconfig-0-r1[${MULTILIB_USEDEP}]"

PATCHES=( "${FILESDIR}/${PN}-1.8.1-gl.patch" )
DOCS=( AUTHORS NEWS README VERSION )

src_prepare() {
	default
	eautoreconf

	if use cuda ; then
		append-cflags "-I${EPREFIX}/opt/cuda/include"
		append-cppflags "-I${EPREFIX}/opt/cuda/include"
	fi
}

multilib_src_configure() {
	export HWLOC_PKG_CONFIG="$(tc-getPKG_CONFIG)" #393467

	if use cuda ; then
		local -x LDFLAGS="${LDFLAGS}"
		append-ldflags "-L${EPREFIX}/opt/cuda/$(get_libdir)"
	fi

	local myconf=(
		--disable-opencl
		--enable-shared
		$(multilib_native_use_enable cuda)
		$(multilib_native_use_enable gl)
		$(use_enable cairo)
		$(use_enable cpuid)
		$(use_enable debug)
		$(use_enable libudev)
		$(use_enable netloc)
		$(use_enable nvml)
		$(use_enable pci)
		$(use_enable plugins)
		$(use_enable static-libs static)
		$(use_enable xml libxml2)
		$(use_with X x)
	)
	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install_all() {
	default
	systemd_dounit "${D}/usr/share/hwloc/hwloc-dump-hwdata.service"
	find "${D}" -name '*.la' -delete || die
}
