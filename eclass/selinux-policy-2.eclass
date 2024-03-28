# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Eclass for installing SELinux policy, and optionally
# reloading the reference-policy based modules.

# @ECLASS: selinux-policy-2.eclass
# @MAINTAINER:
# selinux@gentoo.org
# @SUPPORTED_EAPIS: 7
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
	7) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_SELINUX_POLICY_2_ECLASS} ]]; then
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

# @ECLASS_VARIABLE: POLICY_TYPES
# @DESCRIPTION:
# This variable informs the eclass for which SELinux policies the module should
# be built. Currently, Gentoo supports targeted, strict, mcs and mls.
# This variable is the same POLICY_TYPES variable that we tell SELinux
# users to set in make.conf. Therefore, it is not the module that should
# override it, but the user.
: "${POLICY_TYPES:="targeted strict mcs mls"}"

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

inherit selinux-policy-utils

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
	local path_to_patch='' policy_files_dir=${FILESDIR}
	local -a policy_files=()

	if [[ -n ${BASEPOL} ]] && [[ "${BASEPOL}" != "9999" ]]; then
		path_to_patch="${WORKDIR}/0001-full-patch-against-stable-release.patch"
	fi

	if [[ $(declare -p POLICY_FILES 2>/dev/null 2>&1) == "declare -a"* ]]; then
		local -n policy_files=POLICY_FILES
	else
		local -a policy_files=( ${POLICY_FILES} )
	fi

	selinux-policy-utils-prepare \
		"${path_to_patch}" "${policy_files_dir}" "${S}" \
		${POLICY_TYPES} -- ${MODS} -- "${policy_files[@]}"
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

	selinux-policy-utils-compile-policy-packages "${S}" "${makeuse}" ${POLICY_TYPES}
}

# @FUNCTION: selinux-policy-2_src_install
# @DESCRIPTION:
# Install the built .pp (or copied .cil) files in the correct subdirectory within
# /usr/share/selinux.
selinux-policy-2_src_install() {
	if [[ $(declare -p POLICY_FILES 2>/dev/null 2>&1) == "declare -a"* ]]; then
		local -n policy_files=POLICY_FILES
	else
		local -a policy_files=( ${POLICY_FILES} )
	fi

	selinux-policy-utils-install-policy-packages \
		"${S}" ${POLICY_TYPES} -- ${MODS} -- "${policy_files[@]}"
}

# @FUNCTION: selinux-policy-2_pkg_postinst
# @DESCRIPTION:
# Install the built .pp (or copied .cil) files in the SELinux policy stores, effectively
# activating the policy on the system.
selinux-policy-2_pkg_postinst() {
	local full_reload_on_failure=1

	selinux-policy-utils-load-policy-packages \
		"${ROOT}" "${full_reload_on_failure}" ${POLICY_TYPES} -- ${MODS}
	selinux-policy-utils-relabel-deps "${ROOT}" "${CATEGORY}/${PN}"
}

# @FUNCTION: selinux-policy-2_pkg_postrm
# @DESCRIPTION:
# Uninstall the module(s) from the SELinux policy stores, effectively
# deactivating the policy on the system.
selinux-policy-2_pkg_postrm() {
	# Only if we are not upgrading
	if [[ -z "${REPLACED_BY_VERSION}" ]]; then
		selinux-policy-utils-unload-policy-packages \
			"${ROOT}" ${POLICY_TYPES} -- ${MODS}
	fi
}

fi

EXPORT_FUNCTIONS src_unpack src_prepare src_compile src_install pkg_postinst pkg_postrm
