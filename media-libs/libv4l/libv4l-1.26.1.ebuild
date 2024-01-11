# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-info meson-multilib systemd udev xdg

MY_P="v4l-utils-${PV}"

DESCRIPTION="v4l-utils libraries and optional utilities"
HOMEPAGE="https://git.linuxtv.org/v4l-utils.git"
SRC_URI="https://linuxtv.org/downloads/v4l-utils/${MY_P}.tar.xz"

LICENSE="LGPL-2.1+"
SLOT="0/0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE="bpf doc dvb jpeg qt5 tracer +utils"

REQUIRED_USE="
	bpf? ( utils )
	qt5? ( utils )
	tracer? ( utils )
"

RDEPEND="
	dvb? ( virtual/libudev[${MULTILIB_USEDEP}] )
	jpeg? ( media-libs/libjpeg-turbo:=[${MULTILIB_USEDEP}] )
	utils? (
		!elibc_glibc? ( sys-libs/argp-standalone )
		bpf? (
			dev-libs/libbpf:=
			virtual/libelf:=
		)
		qt5? (
			dev-qt/qtcore:5
			dev-qt/qtgui:5
			dev-qt/qtopengl:5[-gles2-only(-),-gles2(-)]
			dev-qt/qtwidgets:5
			media-libs/alsa-lib
			virtual/opengl
		)
		tracer? ( dev-libs/json-c:= )
		virtual/libudev
	)
	!<media-tv/v4l-utils-1.26
"

DEPEND="
	${RDEPEND}
"

BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
	bpf? ( sys-devel/clang:*[llvm_targets_BPF] )
	doc? ( app-text/doxygen )
	utils? (
		dev-lang/perl
		qt5? ( dev-qt/qtcore:5 )
	)
"

# Not really prebuilt but BPF objects make our QA checks go crazy.
QA_PREBUILT="*/rc_keymaps/protocols/*.o"

S="${WORKDIR}/${MY_P}"

PATCHES=(
	"${FILESDIR}"/${PN}-1.26.0-meson.patch
)

check_llvm() {
	if [[ ${MERGE_TYPE} != binary ]] && use bpf; then
		local clang=${ac_cv_prog_CLANG:-${CLANG:-clang}}
		${clang} -target bpf -print-supported-cpus &>/dev/null ||
			die "${clang} does not support the BPF target. Please check LLVM_TARGETS."
	fi
}

pkg_pretend() {
	has_version -b sys-devel/clang && check_llvm
}

pkg_setup() {
	check_llvm
	CONFIG_CHECK="~SHMEM" linux-info_pkg_setup
}

multilib_src_configure() {
	local emesonargs=(
		$(meson_native_use_feature bpf)
		-Dgconv=disabled
		$(meson_feature jpeg)
		$(meson_feature dvb libdvbv5)
		$(meson_native_use_feature qt5 qv4l2)
		$(meson_native_use_feature qt5 qvidcap)
		$(meson_native_use_feature tracer v4l2-tracer)
		$(meson_native_use_bool utils v4l-utils)
		-Ddocdir="${EPREFIX}/usr/share/doc/${PF}"
		-Dsystemdsystemunitdir="$(systemd_get_systemunitdir)"
		-Dudevdir="$(get_udevdir)"
		$(meson_native_use_feature doc doxygen-doc)
		$(meson_native_use_bool doc doxygen-html)
		$(meson_native_use_bool doc doxygen-man)
	)
	meson_src_configure
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

	if use utils && [[ -n ${REPLACING_VERSIONS} ]] && ver_test 1.20.0 -ge ${REPLACING_VERSIONS%% *}; then
		ewarn "WARNING! ir-keytable has changed significantly from version 1.20.0 so"
		ewarn "you may need to take action to avoid breakage. See"
		ewarn "https://bugs.gentoo.org/767175 for more details."
	fi
}

pkg_postrm() {
	xdg_pkg_postrm
	use utils && udev_reload
}
