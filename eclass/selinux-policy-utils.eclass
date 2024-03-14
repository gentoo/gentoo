# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# Eclass for installing SELinux policy, and optionally
# reloading the reference-policy based modules.

# @ECLASS: selinux-policy-2.eclass
# @MAINTAINER:
# selinux@gentoo.org
# @SUPPORTED_EAPIS: 7 8
# @BLURB: This eclass implements common operations for SELinux modules in sec-policy
# @DESCRIPTION:
# The selinux-policy-utils.eclass supports deployment of the various SELinux modules
# defined in the sec-policy category. It is responsible for extracting the
# specific bits necessary for single-module deployment (instead of full-blown
# policy rebuilds) and applying the necessary patches.
#
# Also, it supports for bundling patches to make the whole thing just a bit more
# manageable.
#
# This eclass should not be used directly, use selinux-policy-2.eclass instead.

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ! ${_SELINUX_POLICY_UTILS_ECLASS} ]]; then
_SELINUX_POLICY_UTILS_ECLASS=1

# @FUNCTION: selinux-policy-utils-prepare
# @USAGE: <path to patch> <policy files dir> <source dir> <policy types...> -- <modules...> -- <policy files...> -- <policy patches...>
# @DESCRIPTION:
# Patch the reference policy sources with our set of enhancements.  Start with
# the base patchbundle named 0001-full-patch-against-stable-release.patch
# sitting in workdir, then apply the additional patches as offered by the
# ebuild.
#
# Next, extract only those files needed for this particular module (i.e. the .te
# and .fc files for the given module in the MODS variable).
#
# Finally, prepare the build environments for each of the supported SELinux
# types (such as targeted or strict).
selinux-policy-utils-prepare() {
	local path_to_patch policy_files_dir s
	local -a policy_types mods policy_files policy_patches
	_spu_splice_params path_to_patch policy_files_dir s policy_types mods policy_files policy_patches -- "${@}"

	# Create 3rd_party location for user-contributed policies.
	mkdir "${s}/refpolicy/policy/modules/3rd_party" ||
		die "Failed to create directory ${s}/refpolicy/policy/modules/3rd_party"

	# Patch the sources with the base patchbundle if asked for it.
	if [[ -n ${path_to_patch} ]]; then
		pushd "${s}" >/dev/null || die "Could not enter ${s}"
		einfo "Applying SELinux policy updates ... "
		eapply -p0 -- "${path_to_patch}"
		popd >/dev/null || die "Could not go back to old directory"
	fi

	# Call in eapply_user. We do this early on as we start moving
	# files left and right hereafter.
	eapply_user

	# Copy additional files to the 3rd_party/ location.
	local polfile add_interfaces=0
	if [[ ${#policy_files[@]} -gt 0 ]]; then
		add_interfaces=1
		pushd "${s}/refpolicy/policy/modules" >/dev/null || die "Could not enter ${s}/refpolicy/policy/modules"
		for polfile in "${policy_files[@]}"; do
			cp "${policy_files_dir}/${polfile}" 3rd_party/ || die "Could not copy ${polfile} to 3rd_party/ location";
		done
		popd >/dev/null || die "Could not go back to old directory"
	fi

	# Apply the additional patches referred to by the module ebuild.
	if [[ ${#policy_patches[@]} -gt 0 ]]; then
		eapply -d "${s}/refpolicy/policy/modules" -- "${policy_patches[@]}"
	fi

	# Collect only those files needed for this particular module
	local mod
	local -a modfiles tmpmodfiles
	for mod in "${mods[@]}"; do
		mapfile -t tmpmodfiles < <(
			find "${s}/refpolicy/policy/modules" -iname "${mod}.te"
			find "${s}/refpolicy/policy/modules" -iname "${mod}.fc"
			find "${s}/refpolicy/policy/modules" -iname "${mod}.cil"
			if [[ ${add_interfaces} -eq 1 ]]; then
				find "${S}/refpolicy/policy/modules" -iname "${mod}.if"
			fi
		)
		modfiles+=( "${tmpmodfiles[@]}" )
	done

	local pt ptdir
	for pt in "${policy_types[@]}"; do
		ptdir="${s}/${pt}"
		mkdir "${ptdir}" || die "Failed to create directory ${ptdir}"
		cp "${s}/refpolicy/doc/Makefile.example" "${ptdir}/Makefile" \
			|| die "Failed to copy Makefile.example to ${ptdir}/Makefile"

		cp "${modfiles[@]}" "${ptdir}" \
			|| die "Failed to copy the module files to ${ptdir}"
	done
}

# @FUNCTION: selinux-policy-utils-compile-policy-packages
# @USAGE: <source dir> <M4PARAM value> <policy types...>
# @DESCRIPTION:
# Build the SELinux policy module (.pp file) for the selected modules, and this
# for each SELinux policy.
selinux-policy-utils-compile-policy-packages() (
	local s m4param
	local -a policy_types
	_spu_splice_params s m4param policy_types -- "${@}"

	# Support USE flags in builds
	if [[ -n "${m4param}" ]]; then
		export M4PARAM="${m4param}"
	fi
	local pt
	for pt in "${policy_types[@]}"; do
		# TODO: EPREFIX or SYSROOT? ESYSROOT?
		emake NAME="${pt}" SHAREDIR="${EPREFIX}/usr/share/selinux" -C "${s}/${pt}"
	done
)

# @FUNCTION: selinux-policy-utils-install-policy-packages
# @USAGE: <source dir> <policy types...> -- <modules...> -- <policy files...>
# @DESCRIPTION:
# Install the built .pp (or copied .cil) files in the correct subdirectory within
# /usr/share/selinux.
selinux-policy-utils-install-policy-packages() {
	local s
	local -a policy_types mods policy_files
	_spu_splice_params s policy_types mods policy_files -- "${@}"

	local pf
	local -A pf_set=()
	for pf in "${policy_files[@]}"; do
		pf_set["${pf}"]=x
	done

	local basedir="/usr/share/selinux" pt mod ptdir
	for pt in "${policy_types[@]}"; do
		ptdir="${s}/${pt}"
		for mod in "${mods[@]}"; do
			einfo "Installing ${pt} ${mod} policy package"
			insinto "${basedir}/${pt}"
			if [[ -f "${ptdir}/${mod}.pp" ]] ; then
				doins "${ptdir}/${mod}.pp" || die "Failed to add ${mod}.pp to ${pt}"
			elif [[ -f "${ptdir}/${mod}.cil" ]] ; then
				doins "${ptdir}/${mod}.cil" || die "Failed to add ${mod}.cil to ${pt}"
			fi

			if [[ -n ${pf_set["${mod}.if"]:-} ]]; then
				insinto "${basedir}/${pt}/include/3rd_party"
				doins "${ptdir}/${mod}.if" || die "Failed to add ${mod}.if to ${pt}"
			fi
		done
	done
}

# @FUNCTION: selinux-policy-utils-unload-policy-packages
# @USAGE: <root> <policy types...> -- <modules...>
# @DESCRIPTION:
# Unload passed modules from each policy type.
selinux-policy-utils-unload-policy-packages() {
	local root
	local -a policy_types mods
	_spu_splice_params root policy_types mods -- "${@}"

	# Set root path and don't load policy into the kernel when cross compiling
	local -a root_opts=()
	if [[ -n ${root} ]]; then
		root_opts=( -p "${root}" -n )
	fi

	local pt mod
	local -A loaded_mods=()
	local -a args=() dropped_mods=()
	for pt in "${policy_types[@]}"; do
		while read -r mod; do
			if [[ ${mod} = 'No modules.' ]]; then
				loaded_mods=()
				break
			fi
			loaded_mods["${mod}"]=x
		done < <(semodule "${root_opts[@]}" -s "${pt}" -l)
		if [[ ${#loaded_mods[@]} -eq 0 ]]; then continue; fi
		args=()
		for mod in "${mods[@]}"; do
			if [[ -n ${loaded_mods["${mod}"]:-} ]]; then
				args+=( -r "${mod}" )
				dropped_mods+=( "${mod}" )
			fi
		done
		if [[ ${#args[@]} -gt 0 ]]; then
			einfo "Removing the following modules from the ${pt} module store: ${dropped_mods[*]}"
			semodule "${root_opts[@]}" -s "${pt}" "${args[@]}"
			if [[ $? -ne 0 ]]; then
				ewarn "SELinux module unload failed.";
			else
				einfo "SELinux modules unloaded successfully."
			fi
		fi
	done
}

# @FUNCTION: selinux-policy-utils-load-policy-packages
# @USAGE: <root> <full reload on failure> <policy types...> -- <modules...>
# @DESCRIPTION:
# Install the built .pp (or copied .cil) files in the SELinux policy stores.
selinux-policy-utils-load-policy-packages() {
	local root full_reload_on_failure
	local -a policy_types mods
	_spu_splice_params root full_reload_on_failure policy_types mods -- "${@}"

	# Set root path and don't load policy into the kernel when cross compiling
	local -a root_opts=()
	if [[ -n ${root} ]]; then
		root_opts=( -p "${root}" -n )
	fi

	local mod i=0 have_unconfined=0
	for mod in "${mods[@]}"; do
		if [[ ${mod} = unconfined ]]; then
			local -a mods_no_unconfined
			mods_no_unconfined=( "${mods[@]:0:${i}}" "${mods[@]:$((i+1))}" )
			have_unconfined=1
			break
		fi
		i=$((i+1))
	done

	# build up the command in the case of multiple modules
	local -a command
	local pt mod mods_name
	for pt in "${policy_types[@]}"; do
		mods_name=mods
		case ${pt} in
			strict|mcs|mls)
				if [[ ${have_unconfined} -eq 1 ]]; then
					einfo "Ignoring loading of unconfined module in ${pt} module store.";
					mods_name=mods_no_unconfined
				fi
				;;
		esac
		local -n mods_ref=${mods_name}

		if [[ ${#mods_ref[@]} -eq 0 ]]; then
			continue
		fi
		einfo "Inserting the following modules into the ${pt} module store: ${mods_ref[*]}"

		pushd "${root}/usr/share/selinux/${pt}" >/dev/null || die "Could not enter ${root}/usr/share/selinux/${pt}"
		command=()
		for mod in "${mods_ref[@]}"; do
			if [[ -f "${mod}.pp" ]] ; then
				command+=( -i "${mod}.pp" )
			elif [[ -f "${mod}.cil" ]] ; then
				command+=( -i "${mod}.cil" )
			fi
		done
		unset -n mods_ref

		semodule "${root_opts[@]}" -s "${pt}" "${command[@]}"
		if [[ $? -ne 0 ]]; then
			ewarn "SELinux modules load failed.";
			if [[ ${full_reload_on_failure} -eq 1 ]]; then
				ewarn "Trying full reload...";

				local -a command_base

				_spu_get_semodule_args_for "${pt}" command_base
				semodule "${root_opts[@]}" -s "${pt}" "${command_base[@]}"
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
					ewarn "To reload, run the following command from within /usr/share/selinux/${pt}:"
					ewarn "  semodule -s ${pt@Q} \$(ls *.pp | sed -e 's/^/-i /')"
					ewarn "or"
					ewarn "  semodule -s ${pt@Q} \$(ls *.pp | grep -v unconfined.pp | sed -e 's/^/-i /')"
					ewarn "depending on if you need the unconfined domain loaded as well or not."
				else
					einfo "SELinux modules reloaded successfully."
				fi
			fi
		else
			einfo "SELinux modules loaded successfully."
		fi
		popd >/dev/null || die "Could not go back to old directory"
	done
}

_spu_get_semodule_args_for() {
	local policy_type=${1}
	local -n args=${2}

	local pp
	args=( -i base.pp )
	for pp in *.pp; do
		if [[ ${policy_type} != targeted ]] && [[ ${pp} = unconfined.pp ]]; then continue; fi
		args+=( -i "${pp}" )
	done
}

# @FUNCTION: selinux-policy-utils-relabel-deps
# @USAGE: <root> <pkg>
# @DESCRIPTION:
# Relabel the dependencies of the passed policy package, effectively activating
# the policy on the system.
selinux-policy-utils-relabel-deps() {
	local root=${1} pkg=${2}

	# Don't relabel when cross compiling
	if [[ -n ${root} ]]; then
		return 0
	fi
	if [[ ! -x /sbin/restorecon ]]; then
		ewarn "No restorecon available.";
		return 0
	fi

	# Relabel depending packages
	if [[ -x /usr/bin/qdepends ]] && [[ -x /usr/bin/qlist ]]; then
		_spu_relabel_with_portage_utils "${pkg}"
	elif [[ -x /usr/bin/equery ]] ; then
		_spu_relabel_with_gentoolkit "${pkg}"
	fi
}

_spu_relabel_with_portage_utils() {
	local pkg=${1}

	local -a pkgs
	mapfile -t pkgs < <(/usr/bin/qdepends -C -q -r -Q "${pkg}" | cut -d: -f1 | grep -v "sec-policy/selinux-")
	if [[ ${#pkgs[@]} -eq 0 ]]; then
		return 0
	fi
	einfo "Relabeling contents of the following packages: ${pkgs[*]}"
	/usr/bin/qlist -C -d -o -s --showdebug "${pkgs[@]}" | sort -u | sed -e 's#/$##' | /sbin/restorecon -f -
}

_spu_relabel_with_gentoolkit() {
	local pkg=${1}

	local -a pkgs
	mapfile -t pkgs < <(/usr/bin/equery -C -q depends "${pkg}" | grep -v "sec-policy/selinux-")
	if [[ ${#pkgs[@]} -eq 0 ]]; then
		return 0
	fi
	einfo "Relabeling contents of the following packages: ${pkgs[*]}"
	/usr/bin/equery -C -q files "${pkgs[@]}" | grep -v -x '[[:space:]]*' | /sbin/restorecon -f -
}

_spu_splice_params() {
	local -a args
	local to_shift=0

	_spu_params args to_shift "${@}"
	shift "${to_shift}"

	local a decl
	for a in "${args[@]}"; do
		decl=$(declare -p "${a}" 2>/dev/null)
		case ${decl} in
		'declare --'*)
			local -n var=${a}
			var=${1}
			shift
			unset -n var
			;;
		'declare -a'*)
			_spu_params "${a}" to_shift "${@}"
			shift "${to_shift}"
			;;
		*)
			die "Invalid var kind ${kind}"
			;;
		esac
	done
	if [[ ${#} -gt 0 ]]; then
		die "Incomplete param splice"
	fi
}

_spu_params() {
	local -n _spu_array=${1}
	local -n _spu_to_shift=${2}
	shift 2

	local i=0 j=0 p
	for p; do
		i=$((i+1))
		if [[ ${p} = -- ]]; then
			break
		fi
		j=$((j+1))
	done
	_spu_array=( "${@:1:${j}}" )
	_spu_to_shift=${i}
}

fi
