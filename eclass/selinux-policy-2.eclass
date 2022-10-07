# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Eclass for installing SELinux policy, and optionally
# reloading the reference-policy based modules.

# @ECLASS: selinux-policy-2.eclass
# @MAINTAINER:
# selinux@gentoo.org
# @SUPPORTED_EAPIS: 6 7
# @BLURB: This eclass supports the deployment of the various SELinux modules in sec-policy
# @DESCRIPTION:
# The selinux-policy-2.eclass supports deployment of the various SELinux modules
# defined in the sec-policy category. It is responsible for extracting the
# specific bits necessary for single-module deployment (instead of full-blown
# policy rebuilds) and applying the necessary patches.
#
# Also, it supports for bundling patches to make the whole thing just a bit more
# manageable.

# @ECLASS_VARIABLE: MODS
# @DESCRIPTION:
# This variable contains the (upstream) module name for the SELinux module.
# This name is only the module name, not the category!
: ${MODS:="_illegal"}

# @ECLASS_VARIABLE: BASEPOL
# @DESCRIPTION:
# This variable contains the version string of the selinux-base-policy package
# that this module build depends on. It is used to patch with the appropriate
# patch bundle(s) that are part of selinux-base-policy.
: ${BASEPOL:=${PVR}}

# @ECLASS_VARIABLE: POLICY_PATCH
# @DESCRIPTION:
# This variable contains the additional patch(es) that need to be applied on top
# of the patchset already contained within the BASEPOL variable. The variable
# can be both a simple string (space-separated) or a bash array.
: ${POLICY_PATCH:=""}

# @ECLASS_VARIABLE: POLICY_FILES
# @DESCRIPTION:
# When defined, this contains the files (located in the ebuilds' files/
# directory) which should be copied as policy module files into the store.
# Generally, users would want to include at least a .te and .fc file, but .if
# files are supported as well. The variable can be both a simple string
# (space-separated) or a bash array.
: ${POLICY_FILES:=""}

# @ECLASS_VARIABLE: POLICY_TYPES
# @DESCRIPTION:
# This variable informs the eclass for which SELinux policies the module should
# be built. Currently, Gentoo supports targeted, strict, mcs and mls.
# This variable is the same POLICY_TYPES variable that we tell SELinux
# users to set in make.conf. Therefore, it is not the module that should
# override it, but the user.
: ${POLICY_TYPES:="targeted strict mcs mls"}

# @ECLASS_VARIABLE: SELINUX_GIT_REPO
# @DESCRIPTION:
# When defined, this variable overrides the default repository URL as used by
# this eclass. It allows end users to point to a different policy repository
# using a single variable, rather than having to set the packagename_LIVE_REPO
# variable for each and every SELinux policy module package they want to install.
# The default value is Gentoo's hardened-refpolicy repository.
: ${SELINUX_GIT_REPO:="https://anongit.gentoo.org/git/proj/hardened-refpolicy.git"};

# @ECLASS_VARIABLE: SELINUX_GIT_BRANCH
# @DESCRIPTION:
# When defined, this variable sets the Git branch to use of the repository. This
# allows for users and developers to use a different branch for the entire set of
# SELinux policy packages, rather than having to override them one by one with the
# packagename_LIVE_BRANCH variable.
# The default value is the 'master' branch.
: ${SELINUX_GIT_BRANCH:="master"};

case "${EAPI:-0}" in
	0|1|2|3|4|5) die "EAPI<6 is not supported";;
	6|7) : ;;
	*) die "unknown EAPI" ;;
esac

case ${BASEPOL} in
	9999)	inherit git-r3
			EGIT_REPO_URI="${SELINUX_GIT_REPO}";
			EGIT_BRANCH="${SELINUX_GIT_BRANCH}";
			EGIT_CHECKOUT_DIR="${WORKDIR}/refpolicy";;
esac

IUSE=""

HOMEPAGE="https://wiki.gentoo.org/wiki/Project:SELinux"
if [[ -n ${BASEPOL} ]] && [[ "${BASEPOL}" != "9999" ]]; then
	SRC_URI="https://github.com/SELinuxProject/refpolicy/releases/download/RELEASE_${PV/./_}/refpolicy-${PV}.tar.bz2
		https://dev.gentoo.org/~perfinion/patches/selinux-base-policy/patchbundle-selinux-base-policy-${BASEPOL}.tar.bz2"
elif [[ "${BASEPOL}" != "9999" ]]; then
	SRC_URI="https://github.com/SELinuxProject/refpolicy/releases/download/RELEASE_${PV/./_}/refpolicy-${PV}.tar.bz2"
else
	SRC_URI=""
fi

LICENSE="GPL-2"
SLOT="0"
S="${WORKDIR}/"
PATCHBUNDLE="${DISTDIR}/patchbundle-selinux-base-policy-${BASEPOL}.tar.bz2"

# Modules should always depend on at least the first release of the
# selinux-base-policy for which they are generated.
if [[ -n ${BASEPOL} ]]; then
	RDEPEND=">=sys-apps/policycoreutils-2.0.82
		>=sec-policy/selinux-base-policy-${BASEPOL}"
else
	RDEPEND=">=sys-apps/policycoreutils-2.0.82
		>=sec-policy/selinux-base-policy-${PV}"
fi
if [[ ${EAPI} == 6 ]]; then
	DEPEND="${RDEPEND}
		sys-devel/m4
		>=sys-apps/checkpolicy-2.0.21"
else
	DEPEND="${RDEPEND}"
	BDEPEND="sys-devel/m4
		>=sys-apps/checkpolicy-2.0.21"
fi

EXPORT_FUNCTIONS src_unpack src_prepare src_compile src_install pkg_postinst pkg_postrm

# @FUNCTION: selinux-policy-2_src_unpack
# @DESCRIPTION:
# Unpack the policy sources as offered by upstream (refpolicy).
selinux-policy-2_src_unpack() {
	if [[ "${BASEPOL}" != "9999" ]]; then
		unpack ${A}
	else
		git-r3_src_unpack
	fi
}

# @FUNCTION: selinux-policy-2_src_prepare
# @DESCRIPTION:
# Patch the reference policy sources with our set of enhancements. Start with
# the base patchbundle referred to by the ebuilds through the BASEPOL variable,
# then apply the additional patches as offered by the ebuild.
#
# Next, extract only those files needed for this particular module (i.e. the .te
# and .fc files for the given module in the MODS variable).
#
# Finally, prepare the build environments for each of the supported SELinux
# types (such as targeted or strict), depending on the POLICY_TYPES variable
# content.
selinux-policy-2_src_prepare() {
	local modfiles
	local add_interfaces=0;

	# Create 3rd_party location for user-contributed policies
	cd "${S}/refpolicy/policy/modules" && mkdir 3rd_party;

	# Patch the sources with the base patchbundle
	if [[ -n ${BASEPOL} ]] && [[ "${BASEPOL}" != "9999" ]]; then
		cd "${S}"
		einfo "Applying SELinux policy updates ... "
		eapply -p0 -- "${WORKDIR}/0001-full-patch-against-stable-release.patch"
	fi

	# Call in eapply_user. We do this early on as we start moving
	# files left and right hereafter.
	eapply_user

	# Copy additional files to the 3rd_party/ location
	if [[ "$(declare -p POLICY_FILES 2>/dev/null 2>&1)" == "declare -a"* ]] ||
	   [[ -n ${POLICY_FILES} ]]; then
	    add_interfaces=1;
		cd "${S}/refpolicy/policy/modules"
		for POLFILE in ${POLICY_FILES[@]};
		do
			cp "${FILESDIR}/${POLFILE}" 3rd_party/ || die "Could not copy ${POLFILE} to 3rd_party/ location";
		done
	fi

	# Apply the additional patches refered to by the module ebuild.
	# But first some magic to differentiate between bash arrays and strings
	if [[ "$(declare -p POLICY_PATCH 2>/dev/null 2>&1)" == "declare -a"* ]]; then
		[[ -n ${POLICY_PATCH[*]} ]] && eapply -d "${S}/refpolicy/policy/modules" -- "${POLICY_PATCH[@]}"
	else
		[[ -n ${POLICY_PATCH} ]] && eapply -d "${S}/refpolicy/policy/modules" -- ${POLICY_PATCH}
	fi

	# Collect only those files needed for this particular module
	for i in ${MODS}; do
		modfiles="$(find "${S}/refpolicy/policy/modules" -iname $i.te) $modfiles"
		modfiles="$(find "${S}/refpolicy/policy/modules" -iname $i.fc) $modfiles"
		modfiles="$(find "${S}/refpolicy/policy/modules" -iname $i.cil) $modfiles"
		if [[ ${add_interfaces} -eq 1 ]]; then
			modfiles="$(find "${S}/refpolicy/policy/modules" -iname $i.if) $modfiles"
		fi
	done

	for i in ${POLICY_TYPES}; do
		mkdir "${S}"/${i} || die "Failed to create directory ${S}/${i}"
		cp "${S}"/refpolicy/doc/Makefile.example "${S}"/${i}/Makefile \
			|| die "Failed to copy Makefile.example to ${S}/${i}/Makefile"

		cp ${modfiles} "${S}"/${i} \
			|| die "Failed to copy the module files to ${S}/${i}"
	done
}

# @FUNCTION: selinux-policy-2_src_compile
# @DESCRIPTION:
# Build the SELinux policy module (.pp file) for just the selected module, and
# this for each SELinux policy mentioned in POLICY_TYPES
selinux-policy-2_src_compile() {
	local makeuse=""
	for useflag in ${IUSE};
	do
		use ${useflag} && makeuse="${makeuse} -D use_${useflag}"
	done

	for i in ${POLICY_TYPES}; do
		# Support USE flags in builds
		export M4PARAM="${makeuse}"
		emake NAME=$i SHAREDIR="${ROOT%/}"/usr/share/selinux -C "${S}"/${i} || die "${i} compile failed"
	done
}

# @FUNCTION: selinux-policy-2_src_install
# @DESCRIPTION:
# Install the built .pp (or copied .cil) files in the correct subdirectory within
# /usr/share/selinux.
selinux-policy-2_src_install() {
	local BASEDIR="/usr/share/selinux"

	for i in ${POLICY_TYPES}; do
		for j in ${MODS}; do
			einfo "Installing ${i} ${j} policy package"
			insinto ${BASEDIR}/${i}
			if [[ -f "${S}/${i}/${j}.pp" ]] ; then
			  doins "${S}"/${i}/${j}.pp || die "Failed to add ${j}.pp to ${i}"
			elif [[ -f "${S}/${i}/${j}.cil" ]] ; then
			  doins "${S}"/${i}/${j}.cil || die "Failed to add ${j}.cil to ${i}"
			fi

			if [[ "${POLICY_FILES[@]}" == *"${j}.if"* ]]; then
				insinto ${BASEDIR}/${i}/include/3rd_party
				doins "${S}"/${i}/${j}.if || die "Failed to add ${j}.if to ${i}"
			fi
		done
	done
}

# @FUNCTION: selinux-policy-2_pkg_postinst
# @DESCRIPTION:
# Install the built .pp (or copied .cil) files in the SELinux policy stores, effectively
# activating the policy on the system.
selinux-policy-2_pkg_postinst() {
	# Set root path and don't load policy into the kernel when cross compiling
	local root_opts=""
	if [[ "${ROOT%/}" != "" ]]; then
		root_opts="-p ${ROOT%/} -n"
	fi

	# build up the command in the case of multiple modules
	local COMMAND

	for i in ${POLICY_TYPES}; do
		if [[ "${MODS}" = "unconfined" ]]; then
			case ${i} in
			strict|mcs|mls)
				einfo "Ignoring loading of unconfined module in ${i} module store.";
				continue
				;;
			esac
		fi

		einfo "Inserting the following modules into the $i module store: ${MODS}"

		cd "${ROOT%/}/usr/share/selinux/${i}" || die "Could not enter /usr/share/selinux/${i}"
		for j in ${MODS} ; do
			if [[ -f "${j}.pp" ]] ; then
				COMMAND="${j}.pp ${COMMAND}"
			elif [[ -f "${j}.cil" ]] ; then
				COMMAND="${j}.cil ${COMMAND}"
			fi
		done

		semodule ${root_opts} -s ${i} -i ${COMMAND}
		if [[ $? -ne 0 ]]; then
			ewarn "SELinux module load failed. Trying full reload...";
			local COMMAND_base="-i base.pp"
			if has_version "<sys-apps/policycoreutils-2.5"; then
				COMMAND_base="-b base.pp"
			fi

			if [[ "${i}" == "targeted" ]]; then
				semodule ${root_opts} -s ${i} ${COMMAND_base} -i $(ls *.pp | grep -v base.pp);
			else
				semodule ${root_opts} -s ${i} ${COMMAND_base} -i $(ls *.pp | grep -v base.pp | grep -v unconfined.pp);
			fi
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
				ewarn "command finished succesfully."
				ewarn ""
				ewarn "To reload, run the following command from within /usr/share/selinux/${i}:"
				ewarn "  semodule ${COMMAND_base} -i \$(ls *.pp | grep -v base.pp)"
				ewarn "or"
				ewarn "  semodule ${COMMAND_base} -i \$(ls *.pp | grep -v base.pp | grep -v unconfined.pp)"
				ewarn "depending on if you need the unconfined domain loaded as well or not."
			else
				einfo "SELinux modules reloaded succesfully."
			fi
		else
			einfo "SELinux modules loaded succesfully."
		fi
		COMMAND="";
	done

	# Don't relabel when cross compiling
	if [[ "${ROOT%/}" == "" ]]; then
		# Relabel depending packages
		local PKGSET="";
		if [[ -x /usr/bin/qdepends ]] ; then
			PKGSET=$(/usr/bin/qdepends -Cq -r -Q ${CATEGORY}/${PN} | grep -v "sec-policy/selinux-");
		elif [[ -x /usr/bin/equery ]] ; then
			PKGSET=$(/usr/bin/equery -Cq depends ${CATEGORY}/${PN} | grep -v "sec-policy/selinux-");
		fi
		if [[ -n "${PKGSET}" ]] ; then
			rlpkg ${PKGSET};
		fi
	fi
}

# @FUNCTION: selinux-policy-2_pkg_postrm
# @DESCRIPTION:
# Uninstall the module(s) from the SELinux policy stores, effectively
# deactivating the policy on the system.
selinux-policy-2_pkg_postrm() {
	# Only if we are not upgrading
	if [[ -z "${REPLACED_BY_VERSION}" ]]; then
		# Set root path and don't load policy into the kernel when cross compiling
		local root_opts=""
		if [[ "${ROOT%/}" != "" ]]; then
			root_opts="-p ${ROOT%/} -n"
		fi

		# build up the command in the case of multiple modules
		local COMMAND
		for i in ${MODS}; do
			COMMAND="-r ${i} ${COMMAND}"
		done

		for i in ${POLICY_TYPES}; do
			einfo "Removing the following modules from the $i module store: ${MODS}"

			semodule ${root_opts} -s ${i} ${COMMAND}
			if [[ $? -ne 0 ]]; then
				ewarn "SELinux module unload failed.";
			else
				einfo "SELinux modules unloaded succesfully."
			fi
		done
	fi
}
