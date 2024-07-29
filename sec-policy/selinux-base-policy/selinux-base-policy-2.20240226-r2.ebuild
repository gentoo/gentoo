# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="${SELINUX_GIT_REPO:-https://anongit.gentoo.org/git/proj/hardened-refpolicy.git}"
	EGIT_BRANCH="${SELINUX_GIT_BRANCH:-master}"
	EGIT_CHECKOUT_DIR="${WORKDIR}/refpolicy"

	inherit git-r3
else
	SRC_URI="https://github.com/SELinuxProject/refpolicy/releases/download/RELEASE_${PV/./_}/refpolicy-${PV}.tar.bz2
			https://dev.gentoo.org/~perfinion/patches/${PN}/patchbundle-${PN}-${PVR}.tar.bz2"
	KEYWORDS="amd64 arm arm64 ~mips ~riscv x86"
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

# Code entirely copied from selinux-eclass (cannot inherit due to dependency on
# itself), when reworked reinclude it. Only postinstall (where -b base.pp is
# added) needs to remain then.

pkg_pretend() {
	for i in ${POLICY_TYPES}; do
		if [[ "${i}" == "targeted" ]] && ! use unconfined; then
			die "If you use POLICY_TYPES=targeted, then USE=unconfined is mandatory."
		fi
	done
}

src_prepare() {
	local modfiles

	if [[ ${PV} != 9999* ]]; then
		einfo "Applying SELinux policy updates ... "
		eapply -p0 "${WORKDIR}/0001-full-patch-against-stable-release.patch"
	fi

	eapply_user

	# Collect only those files needed for this particular module
	for i in ${MODS}; do
		modfiles="$(find "${S}"/refpolicy/policy/modules -iname $i.te) $modfiles"
		modfiles="$(find "${S}"/refpolicy/policy/modules -iname $i.fc) $modfiles"
	done

	for i in ${DEL_MODS}; do
		[[ "${MODS}" != *${i}* ]] || die "Duplicate module in MODS and DEL_MODS: ${i}"
	done

	for i in ${POLICY_TYPES}; do
		mkdir "${S}"/${i} || die "Failed to create directory ${S}/${i}"
		cp "${S}"/refpolicy/doc/Makefile.example "${S}"/${i}/Makefile \
			|| die "Failed to copy Makefile.example to ${S}/${i}/Makefile"

		cp ${modfiles} "${S}"/${i} \
			|| die "Failed to copy the module files to ${S}/${i}"
	done
}

src_compile() {
	for i in ${POLICY_TYPES}; do
		emake NAME=$i SHAREDIR="${SYSROOT%/}/usr/share/selinux" -C "${S}"/${i}
	done
}

src_install() {
	local BASEDIR="/usr/share/selinux"

	for i in ${POLICY_TYPES}; do
		for j in ${MODS}; do
			einfo "Installing ${i} ${j} policy package"
			insinto ${BASEDIR}/${i}
			doins "${S}"/${i}/${j}.pp
		done
	done
}

pkg_postinst() {
	# Set root path and don't load policy into the kernel when cross compiling
	local root_opts=""
	if [[ "${ROOT}" != "" ]]; then
		root_opts="-p ${ROOT} -n"
	fi

	# Override the command from the eclass, we need to load in base as well here
	local COMMAND="-i base.pp"
	if has_version "<sys-apps/policycoreutils-2.5"; then
		COMMAND="-b base.pp"
	fi

	for i in ${MODS}; do
		COMMAND="${COMMAND} -i ${i}.pp"
	done

	for i in ${POLICY_TYPES}; do
		einfo "Inserting the following modules, with base, into the $i module store: ${MODS}"

		cd "${ROOT}/usr/share/selinux/${i}"

		semodule ${root_opts} -s ${i} ${COMMAND}

		for mod in ${DEL_MODS}; do
			if semodule ${root_opts} -s ${i} -l | grep -q "\b${mod}\b"; then
				einfo "Removing obsolete ${i} ${mod} policy package"
				semodule ${root_opts} -s ${i} -r ${mod}
			fi
		done
	done

	# Don't relabel when cross compiling
	if [[ "${ROOT}" == "" ]]; then
		# Relabel depending packages
		local PKGSET="";
		if [[ -x /usr/bin/qdepends ]] ; then
			PKGSET=$(/usr/bin/qdepends -Cq -r -Q ${CATEGORY}/${PN} | grep -v 'sec-policy/selinux-');
		elif [[ -x /usr/bin/equery ]] ; then
			PKGSET=$(/usr/bin/equery -Cq depends ${CATEGORY}/${PN} | grep -v 'sec-policy/selinux-');
		fi
		if [[ -n "${PKGSET}" ]] ; then
			rlpkg ${PKGSET};
		fi
	fi
}
