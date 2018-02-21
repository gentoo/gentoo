# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

if [[ ${PV} == 9999* ]]; then
	EGIT_REPO_URI="${SELINUX_GIT_REPO:-git://anongit.gentoo.org/proj/hardened-refpolicy.git https://anongit.gentoo.org/git/proj/hardened-refpolicy.git}"
	EGIT_BRANCH="${SELINUX_GIT_BRANCH:-master}"
	EGIT_CHECKOUT_DIR="${WORKDIR}/refpolicy"

	inherit git-r3
else
	SRC_URI="https://raw.githubusercontent.com/wiki/TresysTechnology/refpolicy/files/refpolicy-${PV}.tar.bz2
			https://dev.gentoo.org/~swift/patches/${PN}/patchbundle-${PN}-${PVR}.tar.bz2"
	KEYWORDS="~amd64 -arm ~arm64 ~mips ~x86"
fi

HOMEPAGE="https://wiki.gentoo.org/wiki/Project:SELinux"
DESCRIPTION="SELinux policy for core modules"

IUSE="systemd +unconfined"

PDEPEND="unconfined? ( sec-policy/selinux-unconfined )"
DEPEND="=sec-policy/selinux-base-${PVR}[systemd?]"

MODS="application authlogin bootloader clock consoletype cron dmesg fstools getty hostname hotplug init iptables libraries locallogin logging lvm miscfiles modutils mount mta netutils nscd portage raid rsync selinuxutil setrans ssh staff storage su sysadm sysnetwork tmpfiles udev userdomain usermanage unprivuser xdg"
LICENSE="GPL-2"
SLOT="0"
S="${WORKDIR}/"

# Code entirely copied from selinux-eclass (cannot inherit due to dependency on
# itself), when reworked reinclude it. Only postinstall (where -b base.pp is
# added) needs to remain then.

pkg_setup() {
	if use systemd; then
		MODS="${MODS} systemd"
	fi
}

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
		modfiles="$(find ${S}/refpolicy/policy/modules -iname $i.te) $modfiles"
		modfiles="$(find ${S}/refpolicy/policy/modules -iname $i.fc) $modfiles"
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
		emake NAME=$i -C "${S}"/${i} || die "${i} compile failed"
	done
}

src_install() {
	local BASEDIR="/usr/share/selinux"

	for i in ${POLICY_TYPES}; do
		for j in ${MODS}; do
			einfo "Installing ${i} ${j} policy package"
			insinto ${BASEDIR}/${i}
			doins "${S}"/${i}/${j}.pp || die "Failed to add ${j}.pp to ${i}"
		done
	done
}

pkg_postinst() {
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

		cd /usr/share/selinux/${i}

		semodule -s ${i} ${COMMAND}
	done

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
}
