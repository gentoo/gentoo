# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

inherit selinux-policy-utils

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="${SELINUX_GIT_REPO:-https://anongit.gentoo.org/git/proj/hardened-refpolicy.git}"
	EGIT_BRANCH="${SELINUX_GIT_BRANCH:-master}"
	EGIT_CHECKOUT_DIR="${WORKDIR}/refpolicy"

	inherit git-r3
else
	SRC_URI="https://github.com/SELinuxProject/refpolicy/releases/download/RELEASE_${PV/./_}/refpolicy-${PV}.tar.bz2
			https://dev.gentoo.org/~perfinion/patches/${PN}/patchbundle-${PN}-${PVR}.tar.bz2"
	KEYWORDS="~amd64 ~arm ~arm64 ~mips ~x86"
fi

HOMEPAGE="https://wiki.gentoo.org/wiki/Project:SELinux"
DESCRIPTION="SELinux policy for core modules"

IUSE="systemd +unconfined"

PDEPEND="unconfined? ( sec-policy/selinux-unconfined )"
DEPEND="=sec-policy/selinux-base-${PVR}[systemd?]"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-apps/checkpolicy
	sys-devel/m4"

MODS="application authlogin bootloader clock consoletype cron dmesg fstools getty hostname init iptables libraries locallogin logging lvm miscfiles modutils mount mta netutils nscd portage raid rsync selinuxutil setrans ssh staff storage su sysadm sysnetwork systemd tmpfiles udev userdomain usermanage unprivuser xdg"
DEL_MODS="hotplug"
LICENSE="GPL-2"
SLOT="0"
S="${WORKDIR}/"

pkg_pretend() {
	local pt

	for pt in ${POLICY_TYPES}; do
		if [[ ${pt} = targeted ]] && ! use unconfined; then
			die "If you use POLICY_TYPES=targeted, then USE=unconfined is mandatory."
		fi
	done
}

src_prepare() {
	local path_to_patch='' policy_files_dir=${FILESDIR}
	# no extra policy files nor patches
	local -a policy_files=() policy_patches=()

	if [[ ${PV} != 9999* ]]; then
		path_to_patch="${WORKDIR}/0001-full-patch-against-stable-release.patch"
	fi

	local mod
	for mod in ${DEL_MODS}; do
		[[ " ${MODS} " != *" ${mod} "* ]] || die "Duplicate module in MODS and DEL_MODS: ${mod}"
	done

	selinux-policy-utils-prepare \
		"${path_to_patch}" "${policy_files_dir}" "${S}" \
		${POLICY_TYPES} -- ${MODS} -- "${policy_files[@]}" -- "${policy_patches[@]}"
}

src_compile() {
	local m4param=''
	selinux-policy-utils-compile-policy-packages "${S}" "${m4param}" ${POLICY_TYPES}
}

src_install() {
	# no extra policy files
	local -a policy_files=()
	selinux-policy-utils-install-policy-packages "${S}" \
		${POLICY_TYPES} -- ${MODS} -- "${policy_files[@]}"
}

pkg_postinst() {
	local full_reload_on_failure=0
	selinux-policy-utils-load-policy-packages "${ROOT}" "${full_reload_on_failure}" \
		${POLICY_TYPES} -- base ${MODS}
	selinux-policy-utils-unload-policy-packages "${ROOT}" ${POLICY_TYPES} -- ${DEL_MODS}
	selinux-policy-utils-relabel-deps "${ROOT}" "${CATEGORY}/${PN}"
}
