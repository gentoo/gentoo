# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools bash-completion-r1 cuda flag-o-matic systemd toolchain-funcs multilib-minimal

MY_PV="v$(ver_cut 1-2)"
DESCRIPTION="Displays the hardware topology in convenient formats"
HOMEPAGE="https://www.open-mpi.org/projects/hwloc/"
SRC_URI="https://www.open-mpi.org/software/${PN}/${MY_PV}/downloads/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0/15"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ~ppc64 ~riscv ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="cairo +cpuid cuda debug nvml +pci static-libs svg udev xml X video_cards_nvidia"

# opencl: opencl support dropped with x11-drivers/ati-drivers being removed (bug #582406).
#         anyone with hardware is welcome to step up and help test to get it re-added.
# video-cards_nvidia: libXext/libX11 deps are only here, see HWLOC_GL_REQUIRES usage in config/hwloc.m4
RDEPEND=">=sys-libs/ncurses-5.9-r3:=[${MULTILIB_USEDEP}]
	cairo? ( >=x11-libs/cairo-1.12.14-r4[X?,svg(+)?,${MULTILIB_USEDEP}] )
	cuda? ( >=dev-util/nvidia-cuda-toolkit-6.5.19-r1:= )
	nvml? ( x11-drivers/nvidia-drivers[${MULTILIB_USEDEP}] )
	pci? (
		>=sys-apps/pciutils-3.3.0-r2[${MULTILIB_USEDEP}]
		>=x11-libs/libpciaccess-0.13.1-r1[${MULTILIB_USEDEP}]
	)
	udev? ( virtual/libudev:= )
	xml? ( >=dev-libs/libxml2-2.9.1-r4[${MULTILIB_USEDEP}] )
	video_cards_nvidia? (
		x11-drivers/nvidia-drivers[static-libs]
		x11-libs/libXext
		x11-libs/libX11
	)"
DEPEND="${RDEPEND}"
# 2.69-r5 for --runstatedir
BDEPEND=">=sys-devel/autoconf-2.69-r5
	virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-1.8.1-gl.patch" )

DOCS=( AUTHORS NEWS README VERSION )

src_prepare() {
	default

	eautoreconf
}

multilib_src_configure() {
	# bug #393467
	export HWLOC_PKG_CONFIG="$(tc-getPKG_CONFIG)"

	if use video_cards_nvidia ; then
		addpredict /dev/nvidiactl
	fi

	if use cuda ; then
		append-cflags "-I${ESYSROOT}/opt/cuda/include"
		append-cppflags "-I${ESYSROOT}/opt/cuda/include"

		local -x LDFLAGS="${LDFLAGS}"
		append-ldflags "-L${ESYSROOT}/opt/cuda/$(get_libdir)"
	fi

	local myconf=(
		--disable-opencl

		# netloc is deprecated upstream, about to be removed
		# bug #796797
		--disable-netloc

		--disable-plugin-ltdl
		--enable-plugins
		--enable-shared
		--runstatedir="${EPREFIX}/run"
		$(multilib_native_use_enable cuda)
		$(multilib_native_use_enable video_cards_nvidia gl)
		$(use_enable cairo)
		$(use_enable cpuid)
		$(use_enable debug)
		$(use_enable udev libudev)
		$(use_enable nvml)
		$(use_enable pci)
		$(use_enable static-libs static)
		$(use_enable xml libxml2)
		$(use_with X x)
	)

	ECONF_SOURCE="${S}" econf "${myconf[@]}"
}

multilib_src_install_all() {
	default

	case ${ARCH} in
		# hwloc-dump-hwdata binary only built on those arches, so don't install non-working unit.
		amd64|x86)
			systemd_dounit "${ED}/usr/share/hwloc/hwloc-dump-hwdata.service"
		;;
	esac

	mv "${ED}"/usr/share/bash-completion/completions/hwloc{,-annotate} || die
	bashcomp_alias hwloc-annotate \
		hwloc-{diff,ps,compress-dir,gather-cpuid,distrib,info,bind,patch,calc,ls,gather-topology}
	bashcomp_alias hwloc-annotate lstopo{,-no-graphics}

	find "${ED}" -name '*.la' -delete || die
}
