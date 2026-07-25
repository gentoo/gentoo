# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="SELinux policy for core modules"
HOMEPAGE="https://wiki.gentoo.org/wiki/Project:SELinux"

if [[ "${PV}" = 9999* ]]; then
	EGIT_REPO_URI="${SELINUX_GIT_REPO:-https://anongit.gentoo.org/git/proj/hardened-refpolicy.git}"
	EGIT_BRANCH="${SELINUX_GIT_BRANCH:-master}"
	EGIT_CHECKOUT_DIR="${WORKDIR}/refpolicy"

	inherit git-r3
else
	MY_PV=$(ver_cut 1-2)
	SRC_URI="https://github.com/SELinuxProject/refpolicy/releases/download/RELEASE_${MY_PV/./_}/refpolicy-${MY_PV}.tar.bz2
		https://dev.gentoo.org/~perfinion/patches/${PN}/patchbundle-${PN}-${PV/_p/-r}.tar.bz2"
	KEYWORDS="amd64 arm arm64 ~riscv x86"
fi

S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
IUSE="
	systemd +unconfined
	+selinux_policy_types_targeted +selinux_policy_types_strict +selinux_policy_types_mcs +selinux_policy_types_mls
"
REQUIRED_USE="
	|| ( selinux_policy_types_targeted selinux_policy_types_strict selinux_policy_types_mcs selinux_policy_types_mls )
	selinux_policy_types_targeted? ( unconfined )
"

PDEPEND="unconfined? ( sec-policy/selinux-unconfined )"
DEPEND="
	~sec-policy/selinux-base-${PV}[selinux_policy_types_targeted?,selinux_policy_types_strict?,selinux_policy_types_mcs?,selinux_policy_types_mls?,systemd?]
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-apps/checkpolicy
	sys-devel/m4
"

PATCHES=(
	"${FILESDIR}/0001-newrole_t-run_init_t-call-auth_run_pam.patch"
)

MODS="application authlogin bootloader clock consoletype cron dmesg fstools getty hostname init iptables libraries locallogin logging lvm miscfiles modutils mount mta netutils nscd portage raid rsync selinuxutil setrans ssh staff storage su sysadm sysnetwork systemd tmpfiles udev userdomain usermanage unprivuser xdg"
# A previous, old release of refpolicy had the hotplug policy module. However,
# it has since been removed[1]. As such, remove it if we see it installed.
# [1] https://github.com/gentoo/hardened-refpolicy/commit/5618680a2e148db02ae5614a13cc878f1616d8a2
DEL_MODS="hotplug"

# Code entirely copied from selinux-eclass (cannot inherit due to dependency on
# itself), when reworked reinclude it. Only postinstall (where -b base.pp is
# added) needs to remain then.

src_prepare() {
	local modfiles

	if [[ "${PV}" != 9999* ]]; then
		einfo "Applying SELinux policy updates ... "
		eapply -p0 "${WORKDIR}/0001-full-patch-against-stable-release.patch"
	fi

	default

	# Collect only those files needed for this particular module
	for mod in ${MODS}; do
		modfiles="$(find "${S}/refpolicy/policy/modules" -iname "${mod}.te") $modfiles"
		modfiles="$(find "${S}/refpolicy/policy/modules" -iname "${mod}.fc") $modfiles"
		modfiles="$(find "${S}/refpolicy/policy/modules" -iname "${mod}.cil") $modfiles"
	done

	# TODO: should probably be done earlier?
	for i in ${DEL_MODS}; do
		[[ "${MODS}" != *${i}* ]] || die "Duplicate module in MODS and DEL_MODS: ${i}"
	done

	for type in targeted strict mcs mls; do
		if use "selinux_policy_types_${type}"; then
			mkdir "${S}/${type}" || die "Failed to create directory ${S}/${type}"
			cp "${S}/refpolicy/doc/Makefile.example" "${S}/${type}/Makefile" \
				|| die "Failed to copy Makefile.example to ${S}/${type}/Makefile"

			cp ${modfiles} "${S}/${type}" \
				|| die "Failed to copy the module files to ${S}/${type}"
		fi
	done
}

src_compile() {
	local makeuse=""
	# We use IUSE instead of USE so that other variables set in the ebuild
	# environment, such as architecture ones, are not included.
	for useflag in ${IUSE}; do
		# Advance past a possible '+' character: that is NOT part of the USE flag,
		# but instead indicates whether it is enabled by default.
		useflag="${useflag##+}"

		# Only additional USE flags defined in our consumers should be added to
		# build options: SELINUX_POLICY_TYPES should NOT be passed to the policy
		# build system.
		[[ "${useflag}" = selinux_policy_types_* ]] && continue

		use ${useflag} && makeuse="${makeuse} -D use_${useflag}"
	done

	for type in targeted strict mcs mls; do
		if use "selinux_policy_types_${type}"; then
			# Support USE flags in builds
			export M4PARAM="${makeuse}"
			emake NAME="${type}" SHAREDIR="${EPREFIX}/usr/share/selinux" -C "${S}/${type}"
		fi
	done
}

src_install() {
	local BASEDIR="/usr/share/selinux"

	for type in targeted strict mcs mls; do
		if use "selinux_policy_types_${type}"; then
			for mod in ${MODS}; do
				einfo "Installing ${type} ${mod} policy package"
				insinto "${BASEDIR}/${type}"
				if [[ -f "${S}/${type}/${mod}.pp" ]]; then
					doins "${S}/${type}/${mod}.pp"
				elif [[ -f "${S}/${type}/${mod}.cil" ]]; then
					doins "${S}/${type}/${mod}.cil"
				fi
			done
		fi
	done
}

pkg_postinst() {
	# Set root path and don't load policy into the kernel when cross compiling
	local root_opts=""
	if [[ -n ${ROOT} ]]; then
		root_opts="-p ${ROOT} -n"
	fi

	# Override the command from the eclass, we need to load in base as well here
	local COMMAND="-i base.pp"

	for type in targeted strict mcs mls; do
		if use "selinux_policy_types_${type}"; then
			einfo "Inserting the following modules, with base, into the ${type} module store: ${MODS}"

			cd "${ROOT}/usr/share/selinux/${type}" || die "Could not enter /usr/share/selinux/${type}"
			for mod in ${MODS}; do
				if [[ -f "${mod}.pp" ]]; then
					COMMAND="${mod}.pp ${COMMAND}"
				elif [[ -f "${mod}.cil" ]]; then
					COMMAND="${mod}.cil ${COMMAND}"
				fi
			done

			semodule ${root_opts} -s ${type} -i ${COMMAND}
			if [[ $? -ne 0 ]]; then
				ewarn "SELinux module load failed. Trying full reload..."

				semodule ${root_opts} -s ${type} -i ./*.pp

				if [[ $? -ne 0 ]]; then
					ewarn "Failed to reload SELinux policies."
					ewarn ""
					ewarn "If this is *not* the last SELinux module package being installed,"
					ewarn "then you can safely ignore this as the reloads will be retried"
					ewarn "with other, recent modules."
					ewarn ""
					ewarn "If it is the last SELinux module package being installed however,"
					ewarn "then it is advised to look at the error above and take appropriate"
					ewarn "action since the new SELinux policies are not loaded until the"
					ewarn "command finished successfully."
					ewarn ""
					ewarn "To reload, run the following command:"
					ewarn "  semodule -i /usr/share/selinux/${type}/*.pp"
				else
					einfo "SELinux modules reloaded successfully."
				fi
			else
				einfo "SELinux modules loaded successfully."
			fi

			# And now, remove any old modules that should no longer be installed.
			for mod in ${DEL_MODS}; do
				if semodule ${root_opts} -s "${type}" -l | grep -q "\b${mod}\b"; then
					einfo "Removing obsolete ${type} ${mod} policy package"
					semodule ${root_opts} -s "${type}" -r "${mod}"
					if [[ $? -ne 0 ]]; then
						ewarn "Failed to remove obsolete ${type} ${mod} policy package"
					fi
				fi
			done

			COMMAND=""
		fi
	done

	# Don't relabel when cross compiling
	if [[ -z ${ROOT} ]]; then
		# Relabel depending packages. This entire section is a hack, and a violation of tree policy;
		# it relies on PM specific functionality (qdepends and equery, which are portage specific) and
		# hence is not PMS compliant. This should be remove and replaced with a more robust, PMS-compliant
		# implementation as soon as possible.
		local PKGSET=()
		local out
		local status
		local cmd

		if command -v qdepends &>/dev/null; then
			out=$(qdepends -CiqqrF '%[CATEGORY]%[PN]%[SLOT]' -Q "${CATEGORY}/${PN}")
			status=$?
			cmd='qdepends'
		elif command -v equery &>/dev/null; then
			out=$(equery -Cq depends "${CATEGORY}/${PN}")
			status=$?
			cmd='equery'
		else
			ewarn "Unable to calculate reverse dependencies for policy: both qdepends and equery were not found."
			ewarn "Skipping package file relabelling..."
			return
		fi

		if [[ "${status}" -ne 0 ]]; then
			ewarn "Failed to calculate reverse dependencies for policy: ${cmd} returned ${status}."
			ewarn "Skipping package file relabelling..."
			return
		fi

		# Policy packages may pull in other policy packages, filter those out.
		readarray -t PKGSET <<<"$(echo "${out}" | grep -v 'sec-policy/selinux-')"

		[[ "${#PKGSET[@]}" -ne 0 ]] && rlpkg "${PKGSET[@]}"
	fi
}
