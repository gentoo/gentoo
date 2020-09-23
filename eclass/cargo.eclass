# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: cargo.eclass
# @MAINTAINER:
# rust@gentoo.org
# @AUTHOR:
# Doug Goldstein <cardoe@gentoo.org>
# @SUPPORTED_EAPIS: 6 7
# @BLURB: common functions and variables for cargo builds

if [[ -z ${_CARGO_ECLASS} ]]; then
_CARGO_ECLASS=1

# we need this for 'cargo vendor' subcommand and net.offline config knob
RUST_DEPEND=">=virtual/rust-1.37.0"

case ${EAPI} in
	7) BDEPEND="${RUST_DEPEND}";;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

inherit multiprocessing toolchain-funcs

EXPORT_FUNCTIONS src_unpack src_configure src_compile src_install src_test

IUSE="${IUSE} debug"

ECARGO_HOME="${WORKDIR}/cargo_home"
ECARGO_VENDOR="${ECARGO_HOME}/gentoo"

# @VARIABLE: myfeatures
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

# @FUNCTION: cargo_crate_uris
# @DESCRIPTION:
# Generates the URIs to put in SRC_URI to help fetch dependencies.
cargo_crate_uris() {
	local -r regex='^([a-zA-Z0-9_\-]+)-([0-9]+\.[0-9]+\.[0-9]+.*)$'
	local crate
	for crate in "$@"; do
		local name version url
		[[ $crate =~ $regex ]] || die "Could not parse name and version from crate: $crate"
		name="${BASH_REMATCH[1]}"
		version="${BASH_REMATCH[2]}"
		url="https://crates.io/api/v1/crates/${name}/${version}/download -> ${crate}.crate"
		echo "${url}"
	done
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
			cargo-snapshot*)
				ebegin "Unpacking ${archive}"
				mkdir -p "${S}"/target/snapshot
				tar -xzf "${DISTDIR}"/${archive} -C "${S}"/target/snapshot --strip-components 2 || die
				# cargo's makefile needs this otherwise it will try to
				# download it
				touch "${S}"/target/snapshot/bin/cargo || die
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
# Runs 'cargo fetch' and vendors downloaded crates for offline use, used in live ebuilds

cargo_live_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	[[ "${PV}" == *9999* ]] || die "${FUNCNAME} only allowed in live/9999 ebuilds"
	[[ "${EBUILD_PHASE}" == unpack ]] || die "${FUNCNAME} only allowed in src_unpack"

	mkdir -p "${S}" || die

	pushd "${S}" > /dev/null || die
	# need to specify CARGO_HOME before cargo_gen_config fired
	CARGO_HOME="${ECARGO_HOME}" cargo fetch || die
	CARGO_HOME="${ECARGO_HOME}" cargo vendor "${ECARGO_VENDOR}" || die
	popd > /dev/null || die

	cargo_gen_config
}

# @FUNCTION: cargo_gen_config
# @DESCRIPTION:
# Generate the $CARGO_HOME/config necessary to use our local registry and settings.
# Cargo can also be configured through environment variables in addition to the TOML syntax below.
# For each configuration key below of the form foo.bar the environment variable CARGO_FOO_BAR
# can also be used to define the value.
# Environment variables will take precedent over TOML configuration,
# and currently only integer, boolean, and string keys are supported.
# For example the build.jobs key can also be defined by CARGO_BUILD_JOBS.
# Or setting CARGO_TERM_VERBOSE=false in make.conf will make build quieter.
cargo_gen_config() {
	debug-print-function ${FUNCNAME} "$@"

	cat <<- EOF > "${ECARGO_HOME}/config"
	[source.gentoo]
	directory = "${ECARGO_VENDOR}"

	[source.crates-io]
	replace-with = "gentoo"
	local-registry = "/nonexistant"

	[net]
	offline = true

	[build]
	jobs = $(makeopts_jobs)

	[term]
	verbose = true
	EOF
	# honor NOCOLOR setting
	[[ "${NOCOLOR}" = true || "${NOCOLOR}" = yes ]] && echo "color = 'never'" >> "${ECARGO_HOME}/config"

	export CARGO_HOME="${ECARGO_HOME}"
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

	tc-export AR CC CXX

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

	set -- cargo install $(has --path ${@} || echo --path ./) \
		--root "${ED}/usr" \
		$(usex debug --debug "") \
		${ECARGO_ARGS[@]} "$@"
	einfo "${@}"
	"${@}" || die "cargo install failed"

	rm -f "${ED}/usr/.crates.toml" || die
	rm -f "${ED}/usr/.crates2.json" || die

	[ -d "${S}/man" ] && doman "${S}/man" || return 0
}

# @FUNCTION: cargo_src_test
# @DESCRIPTION:
# Test the package using cargo test
cargo_src_test() {
	debug-print-function ${FUNCNAME} "$@"

	set -- cargo test $(usex debug "" --release) ${ECARGO_ARGS[@]} "$@"
	einfo "${@}"
	"${@}" || die "cargo test failed"
}

fi
