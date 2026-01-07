# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Eclass for installing SELinux policy, and optionally
# reloading the reference-policy based modules.

# @ECLASS: selinux-policy-2.eclass
# @MAINTAINER:
# selinux@gentoo.org
# @SUPPORTED_EAPIS: 7 8
# @BLURB: This eclass supports the deployment of the various SELinux modules in sec-policy
# @DESCRIPTION:
# The selinux-policy-2.eclass supports deployment of the various SELinux modules
# defined in the sec-policy category. It is responsible for extracting the
# specific bits necessary for single-module deployment (instead of full-blown
# policy rebuilds) and applying the necessary patches.
#
# Also, it supports for bundling patches to make the whole thing just a bit more
# manageable.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_SELINUX_POLICY_2_ECLASS} ]]; then
_SELINUX_POLICY_2_ECLASS=1

# @ECLASS_VARIABLE: MODS
# @DESCRIPTION:
# This variable contains the (upstream) module name for the SELinux module.
# This name is only the module name, not the category!
: "${MODS:="_illegal"}"

# @ECLASS_VARIABLE: BASEPOL
# @DESCRIPTION:
# This variable contains the version string of the selinux-base-policy package
# that this module build depends on. It is used to patch with the appropriate
# patch bundle(s) that are part of selinux-base-policy.
: "${BASEPOL:=${PVR}}"

# @ECLASS_VARIABLE: POLICY_PATCH
# @DESCRIPTION:
# This variable contains the additional patch(es) that need to be applied on top
# of the patchset already contained within the BASEPOL variable. The variable
# can be both a simple string (space-separated) or a bash array.
: "${POLICY_PATCH:=""}"

# @ECLASS_VARIABLE: POLICY_FILES
# @DESCRIPTION:
# When defined, this contains the files (located in the ebuilds' files/
# directory) which should be copied as policy module files into the store.
# Generally, users would want to include at least a .te and .fc file, but .if
# files are supported as well. The variable can be both a simple string
# (space-separated) or a bash array.
: "${POLICY_FILES:=""}"

if [[ ${EAPI} == 7 ]]; then
	# @ECLASS_VARIABLE: POLICY_TYPES
	# @DESCRIPTION:
	# This variable informs the eclass for which SELinux policies the module should
	# be built. Currently, Gentoo supports targeted, strict, mcs and mls.
	# This variable is the same POLICY_TYPES variable that we tell SELinux
	# users to set in make.conf. Therefore, it is not the module that should
	# override it, but the user.
	: "${POLICY_TYPES:="targeted strict mcs mls"}"
fi

# @ECLASS_VARIABLE: SELINUX_GIT_REPO
# @DESCRIPTION:
# When defined, this variable overrides the default repository URL as used by
# this eclass. It allows end users to point to a different policy repository
# using a single variable, rather than having to set the packagename_LIVE_REPO
# variable for each and every SELinux policy module package they want to install.
# The default value is Gentoo's hardened-refpolicy repository.
: "${SELINUX_GIT_REPO:="https://anongit.gentoo.org/git/proj/hardened-refpolicy.git"}"

# @ECLASS_VARIABLE: SELINUX_GIT_BRANCH
# @DESCRIPTION:
# When defined, this variable sets the Git branch to use of the repository. This
# allows for users and developers to use a different branch for the entire set of
# SELinux policy packages, rather than having to override them one by one with the
# packagename_LIVE_BRANCH variable.
# The default value is the 'master' branch.
: "${SELINUX_GIT_BRANCH:="master"}"

case ${BASEPOL} in
	9999)	inherit git-r3
			EGIT_REPO_URI="${SELINUX_GIT_REPO}";
			EGIT_BRANCH="${SELINUX_GIT_BRANCH}";
			EGIT_CHECKOUT_DIR="${WORKDIR}/refpolicy";;
esac

if [[ ${EAPI} == 7 ]]; then
	IUSE=""
else
	# Build all policy types by default
	IUSE="+selinux_policy_types_targeted +selinux_policy_types_strict +selinux_policy_types_mcs +selinux_policy_types_mls"
	REQUIRED_USE="|| ( selinux_policy_types_targeted selinux_policy_types_strict selinux_policy_types_mcs selinux_policy_types_mls )"
fi

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

# Modules should always depend on at least the first release of the
# selinux-base-policy for which they are generated.
if [[ -n ${BASEPOL} ]]; then
	_BASE_POLICY_VERSION="${BASEPOL}"
else
	_BASE_POLICY_VERSION="${PV}"
fi

if [[ ${EAPI} == 7 ]]; then
	RDEPEND=">=sys-apps/policycoreutils-2.5
		>=sec-policy/selinux-base-policy-${_BASE_POLICY_VERSION}"
else
	RDEPEND=">=sys-apps/policycoreutils-2.5
		selinux_policy_types_targeted? (
			>=sec-policy/selinux-base-policy-${_BASE_POLICY_VERSION}[selinux_policy_types_targeted]
		)
		selinux_policy_types_strict? (
			>=sec-policy/selinux-base-policy-${_BASE_POLICY_VERSION}[selinux_policy_types_strict]
		)
		selinux_policy_types_mcs? (
			>=sec-policy/selinux-base-policy-${_BASE_POLICY_VERSION}[selinux_policy_types_mcs]
		)
		selinux_policy_types_mls? (
			>=sec-policy/selinux-base-policy-${_BASE_POLICY_VERSION}[selinux_policy_types_mls]
		)"
fi

unset _BASE_POLICY_VERSION

DEPEND="${RDEPEND}"
BDEPEND="
	sys-devel/m4
	>=sys-apps/checkpolicy-2.0.21
"

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

	# Apply the additional patches referred to by the module ebuild.
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

	_selinux_prepare_modules() {
		mkdir "${S}"/${1} || die "Failed to create directory ${S}/${1}"
		cp "${S}"/refpolicy/doc/Makefile.example "${S}"/${1}/Makefile \
			|| die "Failed to copy Makefile.example to ${S}/${1}/Makefile"

		cp ${modfiles} "${S}"/${1} \
			|| die "Failed to copy the module files to ${S}/${1}"
	}

	if [[ ${EAPI} == 7 ]]; then
		for i in ${POLICY_TYPES}; do
			_selinux_prepare_modules $i
		done
	else
		for i in targeted strict mcs mls; do
			if use selinux_policy_types_${i}; then
				_selinux_prepare_modules $i
			fi
		done
	fi
}

# @FUNCTION: selinux-policy-2_src_compile
# @DESCRIPTION:
# Build the SELinux policy module (.pp file) for just the selected module, and
# this for each SELinux policy mentioned in POLICY_TYPES
selinux-policy-2_src_compile() {
	local makeuse=""
	# We use IUSE instead of USE so that other variables set in the ebuild
	# environment, such as architecture ones, are not included.
	for useflag in ${IUSE};
	do
		# Advance past a possible '+' character: that is NOT part of the USE flag,
		# but instead indicates whether it is enabled by default.
		useflag="${useflag##+}"

		# Only additional USE flags defined in our consumers should be added to
		# build options: SELINUX_POLICY_TYPES should NOT be passed to the policy
		# build system.
		[[ "${useflag}" == selinux_policy_types_* ]] && continue

		use ${useflag} && makeuse="${makeuse} -D use_${useflag}"
	done

	_selinux_compile_modules() {
		# Support USE flags in builds
		export M4PARAM="${makeuse}"
		emake NAME=$1 SHAREDIR="${EPREFIX}"/usr/share/selinux -C "${S}"/${1}
	}

	if [[ ${EAPI} == 7 ]]; then
		for i in ${POLICY_TYPES}; do
			_selinux_compile_modules $i
		done
	else
		for i in targeted strict mcs mls; do
			if use selinux_policy_types_${i}; then
				_selinux_compile_modules $i
			fi
		done
	fi
}

# @FUNCTION: selinux-policy-2_src_install
# @DESCRIPTION:
# Install the built .pp (or copied .cil) files in the correct subdirectory within
# /usr/share/selinux.
selinux-policy-2_src_install() {
	local BASEDIR="/usr/share/selinux"

	_selinux_install_modules() {
		for i in ${MODS}; do
			einfo "Installing ${1} ${i} policy package"
			insinto ${BASEDIR}/${1}
			if [[ -f "${S}/${1}/${i}.pp" ]] ; then
			  doins "${S}"/${1}/${i}.pp || die "Failed to add ${i}.pp to ${1}"
			elif [[ -f "${S}/${1}/${i}.cil" ]] ; then
			  doins "${S}"/${1}/${i}.cil || die "Failed to add ${i}.cil to ${1}"
			fi

			if [[ "${POLICY_FILES[@]}" == *"${i}.if"* ]]; then
				insinto ${BASEDIR}/${1}/include/3rd_party
				doins "${S}"/${1}/${i}.if || die "Failed to add ${i}.if to ${1}"
			fi
		done
	}

	if [[ ${EAPI} == 7 ]]; then
		for i in ${POLICY_TYPES}; do
			_selinux_install_modules $i
		done
	else
		for i in targeted strict mcs mls; do
			if use selinux_policy_types_${i}; then
				_selinux_install_modules $i
			fi
		done
	fi
}

# @FUNCTION: selinux-policy-2_pkg_postinst
# @DESCRIPTION:
# Install the built .pp (or copied .cil) files in the SELinux policy stores, effectively
# activating the policy on the system.
selinux-policy-2_pkg_postinst() {
	# Set root path and don't load policy into the kernel when cross compiling
	local root_opts=""
	if [[ -n ${ROOT} ]]; then
		root_opts="-p ${ROOT} -n"
	fi

	# build up the command in the case of multiple modules
	local COMMAND

	_selinux_postinst() {
		if [[ "${1}" == "strict" ]] && [[ "${MODS}" = "unconfined" ]]; then
			einfo "Ignoring loading of unconfined module in strict module store.";
			continue;
		fi

		einfo "Inserting the following modules into the $i module store: ${MODS}"

		cd "${ROOT}/usr/share/selinux/${1}" || die "Could not enter /usr/share/selinux/${1}"
		for i in ${MODS} ; do
			if [[ -f "${i}.pp" ]] ; then
				COMMAND="${i}.pp ${COMMAND}"
			elif [[ -f "${i}.cil" ]] ; then
				COMMAND="${i}.cil ${COMMAND}"
			fi
		done

		semodule ${root_opts} -s ${1} -i ${COMMAND}
		if [[ $? -ne 0 ]]; then
			ewarn "SELinux module load failed. Trying full reload...";

			semodule ${root_opts} -s ${1} -i ./*.pp

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
				ewarn "  semodule -i /usr/share/selinux/${1}/*.pp"
			else
				einfo "SELinux modules reloaded successfully."
			fi
		else
			einfo "SELinux modules loaded successfully."
		fi
		COMMAND="";
	}

	if [[ ${EAPI} == 7 ]]; then
		for i in ${POLICY_TYPES}; do
			_selinux_postinst $i
		done
	else
		for i in targeted strict mcs mls; do
			if use selinux_policy_types_${i}; then
				_selinux_postinst $i
			fi
		done
	fi

	# Don't relabel when cross compiling
	if [[ -z ${ROOT} ]]; then
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
		if [[ -n ${ROOT} ]]; then
			root_opts="-p ${ROOT} -n"
		fi

		# build up the command in the case of multiple modules
		local COMMAND
		for i in ${MODS}; do
			COMMAND="-r ${i} ${COMMAND}"
		done

		_selinux_postrm() {
			einfo "Removing the following modules from the $1 module store: ${MODS}"

			semodule ${root_opts} -s ${1} ${COMMAND}
			if [[ $? -ne 0 ]]; then
				ewarn "SELinux module unload failed.";
			else
				einfo "SELinux modules unloaded successfully."
			fi
		}

		if [[ ${EAPI} == 7 ]]; then
			for i in ${POLICY_TYPES}; do
				_selinux_postrm $i
			done
		else
			for i in targeted strict mcs mls; do
				if use selinux_policy_types_${i}; then
					_selinux_postrm $i
				fi
			done
		fi
	fi
}

fi

EXPORT_FUNCTIONS src_unpack src_prepare src_compile src_install pkg_postinst pkg_postrm
