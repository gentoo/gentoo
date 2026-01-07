# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit eapi9-ver linux-info meson-multilib systemd udev xdg

MY_P="v4l-utils-${PV}"

DESCRIPTION="v4l-utils libraries and optional utilities"
HOMEPAGE="https://git.linuxtv.org/v4l-utils.git"
SRC_URI="https://linuxtv.org/downloads/v4l-utils/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"
LICENSE="LGPL-2.1+ utils? ( MIT || ( BSD GPL-2 ) )"
SLOT="0/0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="bpf doc dvb jpeg qt6 tracer +utils"

REQUIRED_USE="
	bpf? ( utils )
	qt6? ( utils )
	tracer? ( utils )
"

RDEPEND="
	!<media-tv/v4l-utils-1.26
	dvb? ( virtual/libudev[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	utils? (
		virtual/libudev
		!sys-apps/edid-decode
		!elibc_glibc? (
			sys-libs/argp-standalone
		)
		bpf? (
			dev-libs/libbpf:=
			virtual/libelf:=
		)
		qt6? (
			dev-qt/qtbase:6[gui,opengl,widgets,-gles2-only]
			dev-qt/qt5compat:6
			media-libs/alsa-lib
			virtual/opengl
		)
		tracer? (
			dev-libs/json-c:=
		)
	)
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	bpf? ( || (
		sys-devel/bpf-toolchain
		llvm-core/clang:*[llvm_targets_BPF]
	) )
	doc? ( app-text/doxygen )
	utils? (
		dev-lang/perl
		qt6? ( dev-qt/qtbase:6 )
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.32-bpf-locale.patch
)

# Not really prebuilt but BPF objects make our QA checks go crazy.
QA_PREBUILT="*/rc_keymaps/protocols/*.o"

# This is intended to be preloaded.
QA_SONAME=".*/libv4l2tracer\.so"

check_llvm() {
	if [[ ${MERGE_TYPE} != binary ]] && use bpf &&
		! has_version -b sys-devel/bpf-toolchain && has_version -b llvm-core/clang; then
		clang -target bpf -print-supported-cpus &>/dev/null ||
			die "clang does not support the BPF target. Please check LLVM_TARGETS."
	fi
}

pkg_pretend() {
	check_llvm
}

pkg_setup() {
	check_llvm
	CONFIG_CHECK="~SHMEM" linux-info_pkg_setup
}

src_prepare() {
	default
	use qt6 || sed -i "/^dep_qt6/s/'qt6/&DiSaBlEd/" meson.build || die
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_feature bpf)
		-Dgconv=disabled
		$(meson_feature jpeg)
		$(meson_feature dvb libdvbv5)
		$(meson_native_use_feature tracer v4l2-tracer)
		$(meson_native_use_bool utils v4l-utils)
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Dudevdir="${EPREFIX}$(get_udevdir)"
		$(meson_native_use_feature doc doxygen-doc)
		$(meson_native_use_bool doc doxygen-html)
		$(meson_native_use_bool doc doxygen-man)
	)
	if multilib_is_native_abi && use qt6; then
		emesonargs+=(
			-Dqv4l2=enabled
			-Dqvidcap=enabled
		)
	else
		emesonargs+=(
			-Dqv4l2=disabled
			-Dqvidcap=disabled
		)
	fi
	PATH+=":${BROOT}/usr/lib/bpf-toolchain/bin" meson_src_configure
}

multilib_src_install_all() {
	dodoc ChangeLog README.lib* TODO

	if use utils; then
		dodoc README.md
		newdoc utils/dvb/README README.dvb
		newdoc utils/libv4l2util/TODO TODO.libv4l2util
		newdoc utils/libmedia_dev/README README.libmedia_dev
		newdoc utils/v4l2-compliance/fixme.txt fixme.txt.v4l2-compliance
	fi
}

pkg_postinst() {
	xdg_pkg_postinst
	use utils && udev_reload

	if use utils && ver_replacing -lt 1.20.0; then
		ewarn "WARNING! ir-keytable has changed significantly from version 1.20.0 so"
		ewarn "you may need to take action to avoid breakage. See"
		ewarn "https://bugs.gentoo.org/767175 for more details."
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	use utils && udev_reload
}
