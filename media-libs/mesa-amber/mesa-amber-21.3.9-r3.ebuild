# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit meson-multilib python-any-r1 linux-info

MY_P="${P/-amber}"
MY_P="${MY_P/_/-}"

DESCRIPTION="OpenGL-like graphic library for Linux"
HOMEPAGE="https://docs.mesa3d.org/amber.html"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/mesa.git"
	inherit git-r3
else
	SRC_URI="https://archive.mesa3d.org/${MY_P}.tar.xz"
	KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-solaris"
fi

S="${WORKDIR}/${MY_P}"
EGIT_CHECKOUT_DIR=${S}

LICENSE="MIT SGI-B-2.0"
SLOT="amber"

RADEON_CARDS="r100 r200 radeon"
VIDEO_CARDS="${RADEON_CARDS} i915 i965 intel nouveau"
for card in ${VIDEO_CARDS}; do
	IUSE_VIDEO_CARDS+=" video_cards_${card}"
done

IUSE="${IUSE_VIDEO_CARDS}
	cpu_flags_x86_sse2 debug gles1 +gles2 selinux test valgrind wayland +X
	+zstd"
RESTRICT="!test? ( test )"

LIBDRM_DEPSTRING=">=x11-libs/libdrm-2.4.107"
RDEPEND="
	!media-libs/mesa:amber
	>=media-libs/mesa-25[${MULTILIB_USEDEP}]

	>=dev-libs/expat-2.1.0-r3:=[${MULTILIB_USEDEP}]
	>=media-libs/libglvnd-1.3.2[X?,${MULTILIB_USEDEP}]
	>=virtual/zlib-1.2.8:=[${MULTILIB_USEDEP}]
	selinux? ( sys-libs/libselinux[${MULTILIB_USEDEP}] )
	wayland? (
		>=dev-libs/wayland-1.18.0:=[${MULTILIB_USEDEP}]
		>=dev-libs/wayland-protocols-1.8
	)
	${LIBDRM_DEPSTRING}[video_cards_nouveau?,${MULTILIB_USEDEP}]
	video_cards_intel? (
		!video_cards_i965? ( ${LIBDRM_DEPSTRING}[video_cards_intel] )
	)
	video_cards_i915? ( ${LIBDRM_DEPSTRING}[video_cards_intel] )
	X? (
		>=x11-libs/libX11-1.6.2:=[${MULTILIB_USEDEP}]
		>=x11-libs/libxshmfence-1.1:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXext-1.3.2:=[${MULTILIB_USEDEP}]
		>=x11-libs/libXxf86vm-1.1.3:=[${MULTILIB_USEDEP}]
		>=x11-libs/libxcb-1.13:=[${MULTILIB_USEDEP}]
		x11-libs/libXfixes:=[${MULTILIB_USEDEP}]
	)
	zstd? ( app-arch/zstd:=[${MULTILIB_USEDEP}] )
"
for card in ${RADEON_CARDS}; do
	RDEPEND="${RDEPEND}
		video_cards_${card}? ( ${LIBDRM_DEPSTRING}[video_cards_radeon] )
	"
done

DEPEND="${RDEPEND}
	valgrind? ( dev-debug/valgrind )
	X? (
		x11-libs/libXrandr[${MULTILIB_USEDEP}]
		x11-base/xorg-proto
	)
"
BDEPEND="
	${PYTHON_DEPS}
	app-alternatives/yacc
	app-alternatives/lex
	virtual/pkgconfig
	$(python_gen_any_dep ">=dev-python/mako-0.8.0[\${PYTHON_USEDEP}]")
	wayland? ( dev-util/wayland-scanner )
"

QA_WX_LOAD="
x86? (
	usr/lib/libGLX_amber.so.0.0.0
	usr/lib/libglapi_amber.so.0.0.0
)"

PATCHES=(
	"${FILESDIR}"/${PN}-i915c.patch
	"${FILESDIR}"/${P}-gcc-15.patch
	"${FILESDIR}"/${P}-libnames.patch
)

python_check_deps() {
	python_has_version ">=dev-python/mako-0.8.0[${PYTHON_USEDEP}]"
}

pkg_setup() {
	if use video_cards_i965; then
		if kernel_is -ge 5 11 3; then
			CONFIG_CHECK="~KCMP"
		elif kernel_is -ge 5 11; then
			CONFIG_CHECK="~CHECKPOINT_RESTORE"
		elif kernel_is -ge 5 10 20; then
			CONFIG_CHECK="~KCMP"
		else
			CONFIG_CHECK="~CHECKPOINT_RESTORE"
		fi
		linux-info_pkg_setup
	fi

	python-any-r1_pkg_setup
}

src_prepare() {
	default
	sed -i -e "/^PLATFORM_SYMBOLS/a '__gentoo_check_ldflags__'," \
		bin/symbols-check.py || die # bug #843983
}

multilib_src_configure() {
	local emesonargs=()

	# Intel code
	dri_driver_enable video_cards_i915 i915
	dri_driver_enable video_cards_i965 i965
	if ! use video_cards_i915 && \
		! use video_cards_i965; then
		dri_driver_enable video_cards_intel i915 i965
	fi

	# Nouveau code
	dri_driver_enable video_cards_nouveau nouveau

	# ATI code
	dri_driver_enable video_cards_r100 r100
	dri_driver_enable video_cards_r200 r200
	if ! use video_cards_r100 && \
		! use video_cards_r200; then
		dri_driver_enable video_cards_radeon r100 r200
	fi

	local platforms
	use X && platforms+="x11"
	use wayland && platforms+=",wayland"
	emesonargs+=(-Dplatforms=${platforms#,})

	driver_list() {
		local drivers="$(sort -u <<< "${1// /$'\n'}")"
		echo "${drivers//$'\n'/,}"
	}

	use debug && EMESON_BUILDTYPE=debug

	emesonargs+=(
		-Damber=true
		$(meson_use test build-tests)
		-Dglx=$(usex X dri disabled)
		-Dshared-glapi=enabled
		-Ddri3=enabled
		-Degl=enabled
		-Dgbm=enabled
		$(meson_feature gles1)
		$(meson_feature gles2)
		-Dglvnd=true
		-Dosmesa=false
		-Dllvm=disabled
		$(meson_use selinux)
		$(meson_feature zstd)
		$(meson_use cpu_flags_x86_sse2 sse2)
		-Dvalgrind=$(usex valgrind auto disabled)
		-Ddri-drivers=$(driver_list "${DRI_DRIVERS[*]}")
		-Dgallium-drivers=''
		-Dvulkan-drivers=''
		-Db_ndebug=$(usex debug false true)
	)
	meson_src_configure
}

multilib_src_test() {
	meson_src_test -t 100
}

multilib_src_install_all() {
	# These are provided by media-libs/mesa:0
	local files=(
		"${ED}"/usr/include
		"${ED}"/usr/lib*/pkgconfig
		"${ED}"/usr/share/drirc.d/00-mesa-defaults.conf
	)
	rm -r "${files[@]}" || die

	# Move i915_dri.so -> i915c_dri.so to not conflict with media-libs/mesa:0.
	for dridir in "${ED}"/usr/lib*/dri; do
		if [[ -e ${dridir}/i915_dri.so ]]; then
			mv ${dridir}/i915{,c}_dri.so || die
		fi
	done

	# Move the glvnd file after the one provided by mesa, to have lower priority
	mv "${ED}"/usr/share/glvnd/egl_vendor.d/50_amber.json \
		"${ED}"/usr/share/glvnd/egl_vendor.d/55_amber.json || die
}

# $1 - VIDEO_CARDS flag (check skipped for "--")
# other args - names of DRI drivers to enable
dri_driver_enable() {
	if [[ $1 == -- ]] || use $1; then
		shift
		DRI_DRIVERS+=("$@")
	fi
}
