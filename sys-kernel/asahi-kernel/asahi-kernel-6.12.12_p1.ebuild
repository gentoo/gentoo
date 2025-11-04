# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
K_SECURITY_UNSUPPORTED="1"
ETYPE="sources"
K_NODRYRUN="1"

RUST_MIN_VER="1.76.0"
RUST_REQ_USE='rust-src,rustfmt'

inherit kernel-build rust

MY_P=linux-${PV%.*}
GENPATCHES_P="genpatches-$(ver_cut 1-2)-15"

if [[ ${PV} != ${PV/_rc} ]] ; then
	# $PV is expected to be of following form: 6.0_rc5_p1
	MY_TAG="$(ver_cut 6)"
	MY_BASE="$(ver_rs 2 - $(ver_cut 1-4))"
else
	# $PV is expected to be of following form: 5.19.0_p1
	MY_TAG="$(ver_cut 5)"
	if [[ "$(ver_cut 3)" == "0" ]] ; then
		MY_BASE="$(ver_cut 1-2)"
	else
		MY_BASE="$(ver_cut 1-3)"
	fi
fi

# BASE_ASAHI_TAG is the first used TAG of specific release, i.e. usually
# the first tag of a linux 6.x or linux stable 6.x.y release
ASAHI_TAG="asahi-${MY_BASE}-${MY_TAG}"

CONFIG_VER=6.12.12-400-gentoo
GENTOO_CONFIG_VER=g15
# provide a temporary mirror as long as Fedora's copr dit-git cgit is dissabled
FEDORA_CONFIG_DISTGIT="asahi.jannau.net/cgit/@asahi/kernel"
# FEDORA_CONFIG_DISTGIT="copr-dist-git.fedorainfracloud.org/cgit/@asahi/kernel"
# FEDORA_CONFIG_DISTGIT="copr-dist-git.fedorainfracloud.org/cgit/ngompa/fedora-asahi-dev"
FEDORA_CONFIG_SHA1=9e1743adaacf3d4a2d1aba7ec1e2dce9fef03a07

DESCRIPTION="Asahi Linux kernel sources"
HOMEPAGE="https://asahilinux.org"
SRC_URI="
    https://cdn.kernel.org/pub/linux/kernel/v$(ver_cut 1).x/${MY_P}.tar.xz
    https://github.com/AsahiLinux/linux/compare/v${MY_BASE}...${ASAHI_TAG}.diff
        -> linux-${ASAHI_TAG}.diff
    https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.base.tar.xz
    https://dev.gentoo.org/~mpagano/dist/genpatches/${GENPATCHES_P}.extras.tar.xz
    https://github.com/projg2/gentoo-kernel-config/archive/${GENTOO_CONFIG_VER}.tar.gz
        -> gentoo-kernel-config-${GENTOO_CONFIG_VER}.tar.gz
	https://${FEDORA_CONFIG_DISTGIT}/kernel.git/plain/kernel-aarch64-16k-fedora.config?id=${FEDORA_CONFIG_SHA1}
		-> kernel-aarch64-16k-fedora.config-${CONFIG_VER}
"

S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="asahi/${PVR}"
KEYWORDS="arm64"

IUSE="debug"

# Rust is non-negotiable for the dist kernel
DEPEND="
	${DEPEND}
	dev-util/bindgen
	debug? ( dev-util/pahole )
"

PDEPEND="
	~virtual/dist-kernel-${PV}:asahi
"

QA_FLAGS_IGNORED="
	usr/src/linux-.*/scripts/gcc-plugins/.*.so
	usr/src/linux-.*/vmlinux
	usr/src/linux-.*/arch/powerpc/kernel/vdso.*/vdso.*.so.dbg
"

src_prepare() {
    local PATCHES=(
        # meh, genpatches have no directory
        "${WORKDIR}"/*.patch
        "${DISTDIR}/linux-${ASAHI_TAG}.diff"
        "${FILESDIR}/${PN}-6.8-config-gentoo-Drop-RANDSTRUCT-from-GENTOO_KERNEL_SEL.patch"
    )
	default

	# prepare the default config
	cp "${DISTDIR}/kernel-aarch64-16k-fedora.config-${CONFIG_VER}" ".config" || die

	# ensure a consistant version across kernel and gentoo
	# this passes the ${PV}-as-release check in kernel-install_pkg_preinst()
	# override "-asahi" in localversion.05-asahi with "_pX" to override the
	# kernel's base varsion to gentoo's ${PV}
	echo "-p${MY_TAG}" > localversion.05-asahi
	# use CONFIG_LOCALVERSION to provide "asahi" and "dist" annotations.
	local myversion="-asahi-dist"
	echo "CONFIG_LOCALVERSION=\"${myversion}\"" > "${T}"/version.config || die
	local dist_conf_path="${WORKDIR}/gentoo-kernel-config-${GENTOO_CONFIG_VER}"

	local merge_configs=(
		"${T}"/version.config
		"${dist_conf_path}"/base.config
	)
	use debug || merge_configs+=(
		"${dist_conf_path}"/no-debug.config
		"${FILESDIR}"/linux-6.10_disable_debug_info_btf.config
	)

	# deselect all non APPLE arm64 ARCHs
	merge_configs+=(
		"${FILESDIR}"/linux-6.8_arm64_deselect_non_apple_arch.config
	)
	# adjust base config for Apple silicon systems
	merge_configs+=(
		"${FILESDIR}"/linux-6.8_arch_apple_overrides.config
	)

	# amdgpu no longer builds with clang (issue #113)
	merge_configs+=(
		"${FILESDIR}"/linux-6.10_drop_amdgpu.config
	)

	kernel-build_merge_configs "${merge_configs[@]}"
}

src_install() {
	# call kernel-build's scr_install
	kernel-build_src_install

	# symlink installed *.dtbs back into kernel "source" directory
	for dtb in "${ED}/lib/modules/${KV_FULL}/dtb/apple/"*.dtb; do
		local basedtb=$(basename ${dtb})
		dosym -r "${dtb##${ED}}" "/usr/src/linux-${KV_FULL}/arch/arm64/boot/dts/apple/${basedtb}"
	done
}

pkg_postinst() {
	einfo "For more information about Asahi Linux please visit ${HOMEPAGE},"
	einfo "or consult the Wiki at https://github.com/AsahiLinux/docs/wiki."
	kernel-build_pkg_postinst
}
