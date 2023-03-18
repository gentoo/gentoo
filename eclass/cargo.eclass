# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cargo.eclass
# @MAINTAINER:
# rust@gentoo.org
# @AUTHOR:
# Doug Goldstein <cardoe@gentoo.org>
# Georgy Yakovlev <gyakovlev@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: common functions and variables for cargo builds

case ${EAPI} in
	7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ -z ${_CARGO_ECLASS} ]]; then
_CARGO_ECLASS=1

# check and document RUST_DEPEND and options we need below in case conditions.
# https://github.com/rust-lang/cargo/blob/master/CHANGELOG.md
RUST_DEPEND="virtual/rust"

case ${EAPI} in
	7)
		# 1.37 added 'cargo vendor' subcommand and net.offline config knob
		RUST_DEPEND=">=virtual/rust-1.37.0"
		;;
	8)
		# 1.39 added --workspace
		# 1.46 added --target dir
		# 1.48 added term.progress config option
		# 1.51 added split-debuginfo profile option
		# 1.52 may need setting RUSTC_BOOTSTRAP envvar for some crates
		# 1.53 added cargo update --offline, can be used to update vulnerable crates from pre-fetched registry without editing toml
		RUST_DEPEND=">=virtual/rust-1.53"

		if [[ -z ${CRATES} && "${PV}" != *9999* ]]; then
			eerror "undefined CRATES variable in non-live EAPI=8 ebuild"
			die "CRATES variable not defined"
		fi
		;;
esac

inherit multiprocessing toolchain-funcs

[[ ! ${CARGO_OPTIONAL} ]] && BDEPEND="${RUST_DEPEND}"

IUSE="${IUSE} debug"

ECARGO_HOME="${WORKDIR}/cargo_home"
ECARGO_VENDOR="${ECARGO_HOME}/gentoo"

# @ECLASS_VARIABLE: CRATES
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# bash string containing all crates package wants to download
# used by cargo_crate_uris()
# Example:
# @CODE
# CRATES="
# metal-1.2.3
# bar-4.5.6
# iron_oxide-0.0.1
# "
# inherit cargo
# ...
# SRC_URI="$(cargo_crate_uris)"
# @CODE

# @ECLASS_VARIABLE: GIT_CRATES
# @DEFAULT_UNSET
# @DESCRIPTION:
# bash associative array containing all crates that a package wants
# to be fetch by git.
# The key is the crate name, the value is a semicolon separated list of
# the following fields:
#
# - the URI to to fetch the crate from
#     - this intelligentally handles GitHub URIs and GitLab URIs so
#       just the path is needed.
#     - the string "%commit%" gets replaced with the commit
# - the hash of the commit to use
# - (optional) the path to look for Cargo.toml in
#   - this will also replace  the string "%commit%" with the commit
#   - if this not provided, it will be generated using the crate name and
#     the commit
# Used by cargo_crate_uris
#
# If this is defined, then cargo_src_install will add --frozen to "cargo install"
#
# Example of simple definition of GIT_CRATES without any paths defined
# @CODE
# declare -A GIT_CRATES=(
# 	[home]="https://github.com/rbtcollins/home;a243ee2fbee6022c57d56f5aa79aefe194eabe53"
# )
# @CODE
#
# Example code of how to define GIT_CRATES with paths defined.
# @CODE
# declare -A GIT_CRATES=(
# 	[rustpython-common]="https://github.com/RustPython/RustPython;4f38cb68e4a97aeea9eb19673803a0bd5f655383;RustPython-%commit%/common"
# 	[rustpython-parser]="https://github.com/RustPython/RustPython;4f38cb68e4a97aeea9eb19673803a0bd5f655383;RustPython-%commit%/compiler/parser"
# )
# @CODE

# @ECLASS_VARIABLE: CARGO_OPTIONAL
# @DEFAULT_UNSET
# @PRE_INHERIT
# @DESCRIPTION:
# If set to a non-null value, before inherit cargo part of the ebuild will
# be considered optional. No dependencies will be added and no phase
# functions will be exported.
#
# If you enable CARGO_OPTIONAL, you have to set BDEPEND on virtual/rust
# for your package and call at least cargo_gen_config manually before using
# other src_ functions of this eclass.
# note that cargo_gen_config is automatically called by cargo_src_unpack.

# @ECLASS_VARIABLE: myfeatures
# @DEFAULT_UNSET
# @DESCRIPTION:
# Optional cargo features defined as bash array.
# Should be defined before calling cargo_src_configure().
#
# Example package that has x11 and wayland as features, and disables default.
# @CODE
# src_configure() {
# 	local myfeatures=(
#		$(usex X x11 '')
# 		$(usev wayland)
# 	)
# 	cargo_src_configure --no-default-features
# }
# @CODE

# @ECLASS_VARIABLE: ECARGO_REGISTRY_DIR
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Storage directory for cargo registry.
# Used by cargo_live_src_unpack to cache downloads.
# This is intended to be set by users.
# Ebuilds must not set it.
#
# Defaults to "${DISTDIR}/cargo-registry" it not set.

# @ECLASS_VARIABLE: ECARGO_OFFLINE
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# If non-empty, this variable prevents online operations in
# cargo_live_src_unpack.
# Inherits value of EVCS_OFFLINE if not set explicitly.

# @ECLASS_VARIABLE: EVCS_UMASK
# @USER_VARIABLE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set this variable to a custom umask. This is intended to be set by
# users. By setting this to something like 002, it can make life easier
# for people who use cargo in a home directory, but are in the portage
# group, and then switch over to building with FEATURES=userpriv.
# Or vice-versa.

# @FUNCTION: cargo_crate_uris
# @DESCRIPTION:
# Generates the URIs to put in SRC_URI to help fetch dependencies.
# Uses first argument as crate list.
# If no argument provided, uses CRATES variable.
cargo_crate_uris() {
	local -r regex='^([a-zA-Z0-9_\-]+)-([0-9]+\.[0-9]+\.[0-9]+.*)$'
	local crate crates

	if [[ -n ${@} ]]; then
		crates="$@"
	elif [[ -n ${CRATES} ]]; then
		crates="${CRATES}"
	else
		eerror "CRATES variable is not defined and nothing passed as argument"
		die "Can't generate SRC_URI from empty input"
	fi

	for crate in ${crates}; do
		local name version url
		[[ $crate =~ $regex ]] || die "Could not parse name and version from crate: $crate"
		name="${BASH_REMATCH[1]}"
		version="${BASH_REMATCH[2]}"
		url="https://crates.io/api/v1/crates/${name}/${version}/download -> ${crate}.crate"
		echo "${url}"
	done

	local git_crates_type
	git_crates_type="$(declare -p GIT_CRATES 2>&-)"
	if [[ ${git_crates_type} == "declare -A "* ]]; then
		local crate commit crate_uri crate_dir repo_ext feat_expr

		for crate in "${!GIT_CRATES[@]}"; do
			IFS=';' read -r crate_uri commit crate_dir <<< "${GIT_CRATES[${crate}]}"

			case "${crate_uri}" in
				https://github.com/*)
					repo_ext=".gh"
					repo_name="${crate_uri##*/}"
					crate_uri="${crate_uri%/}/archive/%commit%.tar.gz"
				;;
				https://gitlab.com/*)
					repo_ext=".gl"
					repo_name="${crate_uri##*/}"
					crate_uri="${crate_uri%/}/archive/-/%commit%/${repo_name}/%commit%.tar.gz"
				;;
				*)
					repo_ext=
					repo_name="${crate}"
				;;
			esac

			printf -- '%s -> %s\n' "${crate_uri//%commit%/${commit}}" "${repo_name}-${commit}${repo_ext}.tar.gz"
		done
	elif [[ -n ${git_crates_type} ]]; then
		die "GIT_CRATE must be declared as an associative array"
	fi
}

# @FUNCTION: cargo_gen_config
# @DESCRIPTION:
# Generate the $CARGO_HOME/config necessary to use our local registry and settings.
# Cargo can also be configured through environment variables in addition to the TOML syntax below.
# For each configuration key below of the form foo.bar the environment variable CARGO_FOO_BAR
# can also be used to define the value.
# Environment variables will take precedence over TOML configuration,
# and currently only integer, boolean, and string keys are supported.
# For example the build.jobs key can also be defined by CARGO_BUILD_JOBS.
# Or setting CARGO_TERM_VERBOSE=false in make.conf will make build quieter.
cargo_gen_config() {
	debug-print-function ${FUNCNAME} "$@"

	mkdir -p "${ECARGO_HOME}" || die

	cat > "${ECARGO_HOME}/config" <<- _EOF_ || die "Failed to create cargo config"
	[source.gentoo]
	directory = "${ECARGO_VENDOR}"

	[source.crates-io]
	replace-with = "gentoo"
	local-registry = "/nonexistant"

	[net]
	offline = true

	[build]
	jobs = $(makeopts_jobs)
	incremental = false

	[term]
	verbose = true
	$([[ "${NOCOLOR}" = true || "${NOCOLOR}" = yes ]] && echo "color = 'never'")
	$(_cargo_gen_git_config)
	_EOF_

	export CARGO_HOME="${ECARGO_HOME}"
	_CARGO_GEN_CONFIG_HAS_RUN=1
}

# @FUNCTION: _cargo_gen_git_config
# @USAGE:
# @INTERNAL
# @DESCRIPTION:
# Generate the cargo config for git crates, this will output the
# configuration for cargo to override the cargo config so the local git crates
# specified in GIT_CRATES will be used rather than attempting to fetch
# from git.
#
# Called by cargo_gen_config when generating the config.
_cargo_gen_git_config() {
	local git_crates_type
	git_crates_type="$(declare -p GIT_CRATES 2>&-)"

	if [[ ${git_crates_type} == "declare -A "* ]]; then
		local crate commit crate_uri crate_dir
		local -A crate_patches

		for crate in "${!GIT_CRATES[@]}"; do
			IFS=';' read -r crate_uri commit crate_dir <<< "${GIT_CRATES[${crate}]}"
			: "${crate_dir:=${crate}-%commit%}"
			crate_patches["${crate_uri}"]+="${crate} = { path = \"${WORKDIR}/${crate_dir//%commit%/${commit}}\" };;"
		done

		for crate_uri in "${!crate_patches[@]}"; do
			printf -- "[patch.'%s']\\n%s\n" "${crate_uri}" "${crate_patches["${crate_uri}"]//;;/$'\n'}"
		done

	elif [[ -n ${git_crates_type} ]]; then
		die "GIT_CRATE must be declared as an associative array"
	fi
}

# @FUNCTION: cargo_src_unpack
# @DESCRIPTION:
# Unpacks the package and the cargo registry
cargo_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	mkdir -p "${ECARGO_VENDOR}" || die
	mkdir -p "${S}" || die

	local archive shasum pkg
	for archive in ${A}; do
		case "${archive}" in
			*.crate)
				ebegin "Loading ${archive} into Cargo registry"
				tar -xf "${DISTDIR}"/${archive} -C "${ECARGO_VENDOR}/" || die
				# generate sha256sum of the crate itself as cargo needs this
				shasum=$(sha256sum "${DISTDIR}"/${archive} | cut -d ' ' -f 1)
				pkg=$(basename ${archive} .crate)
				cat <<- EOF > ${ECARGO_VENDOR}/${pkg}/.cargo-checksum.json
				{
					"package": "${shasum}",
					"files": {}
				}
				EOF
				# if this is our target package we need it in ${WORKDIR} too
				# to make ${S} (and handle any revisions too)
				if [[ ${P} == ${pkg}* ]]; then
					tar -xf "${DISTDIR}"/${archive} -C "${WORKDIR}" || die
				fi
				eend $?
				;;
			*)
				unpack ${archive}
				;;
		esac
	done

	cargo_gen_config
}

# @FUNCTION: cargo_live_src_unpack
# @DESCRIPTION:
# Runs 'cargo fetch' and vendors downloaded crates for offline use, used in live ebuilds.
# NOTE: might require passing --frozen to cargo_src_configure if git dependencies are used.
cargo_live_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	[[ "${PV}" == *9999* ]] || die "${FUNCNAME} only allowed in live/9999 ebuilds"
	[[ "${EBUILD_PHASE}" == unpack ]] || die "${FUNCNAME} only allowed in src_unpack"

	mkdir -p "${S}" || die
	mkdir -p "${ECARGO_VENDOR}" || die
	mkdir -p "${ECARGO_HOME}" || die

	local distdir=${PORTAGE_ACTUAL_DISTDIR:-${DISTDIR}}
	: ${ECARGO_REGISTRY_DIR:=${distdir}/cargo-registry}

	local offline="${ECARGO_OFFLINE:-${EVCS_OFFLINE}}"

	if [[ ! -d ${ECARGO_REGISTRY_DIR} && ! ${offline} ]]; then
		(
			addwrite "${ECARGO_REGISTRY_DIR}"
			mkdir -p "${ECARGO_REGISTRY_DIR}"
		) || die "Unable to create ${ECARGO_REGISTRY_DIR}"
	fi

	if [[ ${offline} ]]; then
		local subdir
		for subdir in cache index src; do
			if [[ ! -d ${ECARGO_REGISTRY_DIR}/registry/${subdir} ]]; then
				eerror "Networking activity has been disabled via ECARGO_OFFLINE or EVCS_OFFLINE"
				eerror "However, no valid cargo registry available at ${ECARGO_REGISTRY_DIR}"
				die "Unable to proceed with ECARGO_OFFLINE/EVCS_OFFLINE."
			fi
		done
	fi

	if [[ ${EVCS_UMASK} ]]; then
		local saved_umask=$(umask)
		umask "${EVCS_UMASK}" || die "Bad options to umask: ${EVCS_UMASK}"
	fi

	pushd "${S}" > /dev/null || die

	# Respect user settings befire cargo_gen_config is called.
	if [[ ! ${CARGO_TERM_COLOR} ]]; then
		[[ "${NOCOLOR}" = true || "${NOCOLOR}" = yes ]] && export CARGO_TERM_COLOR=never
		local unset_color=true
	fi
	if [[ ! ${CARGO_TERM_VERBOSE} ]]; then
		export CARGO_TERM_VERBOSE=true
		local unset_verbose=true
	fi

	# Let cargo fetch to system-wide location.
	# It will keep directory organized by itself.
	addwrite "${ECARGO_REGISTRY_DIR}"
	export CARGO_HOME="${ECARGO_REGISTRY_DIR}"

	# Absence of quotes around offline arg is intentional, as cargo bails out if it encounters ''
	einfo "cargo fetch ${offline:+--offline}"
	cargo fetch ${offline:+--offline} || die #nowarn

	# Let cargo copy all required crates to "${WORKDIR}" for offline use in later phases.
	einfo "cargo vendor ${offline:+--offline} ${ECARGO_VENDOR}"
	cargo vendor ${offline:+--offline} "${ECARGO_VENDOR}" || die #nowarn

	# Users may have git checkouts made by cargo.
	# While cargo vendors the sources, it still needs git checkout to be present.
	# Copying full dir is an overkill, so just symlink it.
	if [[ -d ${ECARGO_REGISTRY_DIR}/git ]]; then
		ln -sv "${ECARGO_REGISTRY_DIR}/git" "${ECARGO_HOME}/git" || die
	fi

	popd > /dev/null || die

	# Restore settings if needed.
	[[ ${unset_color} ]] && unset CARGO_TERM_COLOR
	[[ ${unset_verbose} ]] && unset CARGO_TERM_VERBOSE
	if [[ ${saved_umask} ]]; then
		umask "${saved_umask}" || die
	fi

	# After following calls, cargo will no longer use ${ECARGO_REGISTRY_DIR} as CARGO_HOME
	# It will be forced into offline mode to prevent network access.
	# But since we already vendored crates and symlinked git, it has all it needs to build.
	unset CARGO_HOME
	cargo_gen_config
}

# @FUNCTION: cargo_src_configure
# @DESCRIPTION:
# Configure cargo package features and arguments.
# Extra positional arguments supplied to this function
# will be passed to cargo in all phases.
# Make sure all cargo subcommands support flags passed here.
#
# Example for package that explicitly builds only 'baz' binary and
# enables 'barfeature' and optional 'foo' feature.
# will pass '--features barfeature --features foo --bin baz'
# in src_{compile,test,install}
#
# @CODE
# src_configure() {
#	local myfeatures=(
#		barfeature
#		$(usev foo)
#	)
# 	cargo_src_configure --bin baz
# }
# @CODE
#
# In some cases crates may need '--no-default-features' option,
# as there is no way to disable single feature, except disabling all.
# It can be passed directly to cargo_src_configure().
#
# Some live/9999 ebuild may need '--frozen' option, if git crates
# are used.
# Otherwise src_install phase may query network again and fail.
cargo_src_configure() {
	debug-print-function ${FUNCNAME} "$@"

	[[ -z ${myfeatures} ]] && declare -a myfeatures=()
	local myfeaturestype=$(declare -p myfeatures 2>&-)
	if [[ "${myfeaturestype}" != "declare -a myfeatures="* ]]; then
		die "myfeatures must be declared as array"
	fi

	# transform array from simple feature list
	# to multiple cargo args:
	# --features feature1 --features feature2 ...
	# this format is chosen because 2 other methods of
	# listing features (space OR comma separated) require
	# more fiddling with strings we'd like to avoid here.
	myfeatures=( ${myfeatures[@]/#/--features } )

	readonly ECARGO_ARGS=( ${myfeatures[@]} ${@} ${ECARGO_EXTRA_ARGS} )

	[[ ${ECARGO_ARGS[@]} ]] && einfo "Configured with: ${ECARGO_ARGS[@]}"
}

# @FUNCTION: cargo_src_compile
# @DESCRIPTION:
# Build the package using cargo build
cargo_src_compile() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${_CARGO_GEN_CONFIG_HAS_RUN} ]] || \
		die "FATAL: please call cargo_gen_config before using ${FUNCNAME}"

	tc-export AR CC CXX PKG_CONFIG

	set -- cargo build $(usex debug "" --release) ${ECARGO_ARGS[@]} "$@"
	einfo "${@}"
	"${@}" || die "cargo build failed"
}

# @FUNCTION: cargo_src_install
# @DESCRIPTION:
# Installs the binaries generated by cargo
# In come case workspaces need alternative --path parameter
# default is '--path ./' if nothing specified.
# '--path ./somedir' can be passed directly to cargo_src_install()
cargo_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${_CARGO_GEN_CONFIG_HAS_RUN} ]] || \
		die "FATAL: please call cargo_gen_config before using ${FUNCNAME}"

	set -- cargo install $(has --path ${@} || echo --path ./) \
		--root "${ED}/usr" \
		${GIT_CRATES[@]:+--frozen} \
		$(usex debug --debug "") \
		${ECARGO_ARGS[@]} "$@"
	einfo "${@}"
	"${@}" || die "cargo install failed"

	rm -f "${ED}/usr/.crates.toml" || die
	rm -f "${ED}/usr/.crates2.json" || die

	# it turned out to be non-standard dir, so get rid of it future EAPI
	# and only run for EAPI=7
	# https://bugs.gentoo.org/715890
	case ${EAPI:-0} in
		7)
		if [ -d "${S}/man" ]; then
			doman "${S}/man" || return 0
		fi
		;;
	esac
}

# @FUNCTION: cargo_src_test
# @DESCRIPTION:
# Test the package using cargo test
cargo_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	[[ ${_CARGO_GEN_CONFIG_HAS_RUN} ]] || \
		die "FATAL: please call cargo_gen_config before using ${FUNCNAME}"

	set -- cargo test $(usex debug "" --release) ${ECARGO_ARGS[@]} "$@"
	einfo "${@}"
	"${@}" || die "cargo test failed"
}

fi

if [[ ! ${CARGO_OPTIONAL} ]]; then
	EXPORT_FUNCTIONS src_unpack src_configure src_compile src_install src_test
fi
