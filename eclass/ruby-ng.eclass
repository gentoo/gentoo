# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: ruby-ng.eclass
# @MAINTAINER:
# Ruby herd <ruby@gentoo.org>
# @AUTHOR:
# Author: Diego E. Pettenò <flameeyes@gentoo.org>
# Author: Alex Legler <a3li@gentoo.org>
# Author: Hans de Graaff <graaff@gentoo.org>
# @SUPPORTED_EAPIS: 5 6 7 8
# @BLURB: An eclass for installing Ruby packages with proper support for multiple Ruby slots.
# @DESCRIPTION:
# The Ruby eclass is designed to allow an easier installation of Ruby packages
# and their incorporation into the Gentoo Linux system.
#
# Currently available targets are listed in ruby-utils.eclass
#
# This eclass does not define the implementation of the configure,
# compile, test, or install phases. Instead, the default phases are
# used.  Specific implementations of these phases can be provided in
# the ebuild either to be run for each Ruby implementation, or for all
# Ruby implementations, as follows:
#
#  * each_ruby_configure
#  * all_ruby_configure

# @ECLASS_VARIABLE: USE_RUBY
# @DEFAULT_UNSET
# @REQUIRED
# @DESCRIPTION:
# This variable contains a space separated list of targets (see above) a package
# is compatible to. It must be set before the `inherit' call. There is no
# default. All ebuilds are expected to set this variable.

# @ECLASS_VARIABLE: RUBY_PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# A String or Array of filenames of patches to apply to all implementations.

# @ECLASS_VARIABLE: RUBY_OPTIONAL
# @DEFAULT_UNSET
# @DESCRIPTION:
# Set the value to "yes" to make the dependency on a Ruby interpreter
# optional and then ruby_implementations_depend() to help populate
# BDEPEND, DEPEND and RDEPEND.

# @ECLASS_VARIABLE: RUBY_S
# @DEFAULT_UNSET
# @DESCRIPTION:
# If defined this variable determines the source directory name after
# unpacking. This defaults to the name of the package. Note that this
# variable supports a wildcard mechanism to help with github tarballs
# that contain the commit hash as part of the directory name.

# @ECLASS_VARIABLE: RUBY_QA_ALLOWED_LIBS
# @DEFAULT_UNSET
# @DESCRIPTION:
# If defined this variable contains a whitelist of shared objects that
# are allowed to exist even if they don't link to libruby. This avoids
# the QA check that makes this mandatory. This is most likely not what
# you are looking for if you get the related "Missing links" QA warning,
# since the proper fix is almost always to make sure the shared object
# is linked against libruby. There are cases were this is not the case
# and the shared object is generic code to be used in some other way
# (e.g. selenium's firefox driver extension). When set this argument is
# passed to "grep -E" to remove reporting of these shared objects.

local inherits=""
case ${EAPI} in
	5)
		inherits="eutils toolchain-funcs"
		;;
	6)
		inherits="estack toolchain-funcs"
		;;
	*)
		inherits="estack"
		;;
esac

inherit ${inherits} multilib ruby-utils

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_test src_install pkg_setup

# S is no longer automatically assigned when it doesn't exist.
S="${WORKDIR}"

case ${EAPI} in
	5|6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

# @FUNCTION: ruby_implementation_depend
# @USAGE: target [comparator [version]]
# @RETURN: Package atom of a Ruby implementation to be used in dependencies.
# @DESCRIPTION:
# This function returns the formal package atom for a Ruby implementation.
#
# `target' has to be one of the valid values for USE_RUBY (see above)
#
# Set `comparator' and `version' to include a comparator (=, >=, etc.) and a
# version string to the returned string
ruby_implementation_depend() {
	debug-print-function ${FUNCNAME} "${@}"

	_ruby_implementation_depend $1
}

# @FUNCTION: _ruby_get_all_impls
# @INTERNAL
# @RETURN: list of valid values in USE_RUBY
# @DESCRIPTION:
# Return a list of valid implementations in USE_RUBY, skipping the old
# implementations that are no longer supported.
_ruby_get_all_impls() {
	local i
	for i in ${USE_RUBY}; do
		case ${i} in
			# removed implementations
			ruby19|ruby20|ruby21|ruby22|ruby23|ruby24|ruby25|jruby)
				;;
			*)
				echo ${i};;
		esac
	done
}

# @FUNCTION: ruby_samelib
# @RETURN: use flag string with current ruby implementations
# @DESCRIPTION:
# Convenience function to output the use dependency part of a
# dependency. Used as a building block for ruby_add_rdepend() and
# ruby_add_bdepend(), but may also be useful in an ebuild to specify
# more complex dependencies.
ruby_samelib() {
	debug-print-function ${FUNCNAME} "${@}"

	local res=
	for _ruby_implementation in $(_ruby_get_all_impls); do
		has -${_ruby_implementation} $@ || \
			res="${res}ruby_targets_${_ruby_implementation}(-)?,"
	done

	echo "[${res%,}]"
}

_ruby_atoms_samelib_generic() {
	eshopts_push -o noglob
	echo "RUBYTARGET? ("
	for token in $*; do
		case "$token" in
			"||" | "(" | ")" | *"?")
				echo "${token}" ;;
			*])
				echo "${token%[*}[RUBYTARGET(-),${token/*[}" ;;
			*)
				echo "${token}[RUBYTARGET(-)]" ;;
		esac
	done
	echo ")"
	eshopts_pop
}

# @FUNCTION: ruby_implementation_command
# @RETURN: the path to the given ruby implementation
# @DESCRIPTION:
# Not all implementations have the same command basename as the
# target; This function translate between the two
ruby_implementation_command() {
	debug-print-function ${FUNCNAME} "${@}"

	local _ruby_name=$1

	# Add all USE_RUBY values where the flag name diverts from the binary here

	echo $(type -p ${_ruby_name} 2>/dev/null)
}

_ruby_atoms_samelib() {
	local atoms=$(_ruby_atoms_samelib_generic "$*")

	for _ruby_implementation in $(_ruby_get_all_impls); do
		echo "${atoms//RUBYTARGET/ruby_targets_${_ruby_implementation}}"
	done
}

_ruby_wrap_conditions() {
	local conditions="$1"
	local atoms="$2"

	for condition in $conditions; do
		atoms="${condition}? ( ${atoms} )"
	done

	echo "$atoms"
}

# @FUNCTION: ruby_add_rdepend
# @USAGE: dependencies
# @DESCRIPTION:
# Adds the specified dependencies, with use condition(s) to RDEPEND,
# taking the current set of ruby targets into account. This makes sure
# that all ruby dependencies of the package are installed for the same
# ruby targets. Use this function for all ruby dependencies instead of
# setting RDEPEND yourself. The list of atoms uses the same syntax as
# normal dependencies.
#
# Note: runtime dependencies are also added as build-time test
# dependencies.
ruby_add_rdepend() {
	debug-print-function ${FUNCNAME} "${@}"

	case $# in
		1) ;;
		2)
			case ${EAPI} in
				5|6)
					[[ "${GENTOO_DEV}" == "yes" ]] && eqawarn "You can now use the usual syntax in ruby_add_rdepend for $CATEGORY/$PF"
					ruby_add_rdepend "$(_ruby_wrap_conditions "$1" "$2")"
					return
					;;
				*)
					die "Use the usual depend syntax with a single argument in ruby_add_rdepend"
					;;
			esac
			;;
		*)
			die "bad number of arguments to $0"
			;;
	esac

	local dependency=$(_ruby_atoms_samelib "$1")

	RDEPEND="${RDEPEND} $dependency"

	# Add the dependency as a test-dependency since we're going to
	# execute the code during test phase.
	case ${EAPI} in
		5|6) DEPEND="${DEPEND} test? ( ${dependency} )" ;;
		*) BDEPEND="${BDEPEND} test? ( ${dependency} )" ;;
	esac
	if ! has test "$IUSE"; then
		IUSE+=" test"
		RESTRICT+=" !test? ( test )"
	fi
}

# @FUNCTION: ruby_add_bdepend
# @USAGE: dependencies
# @DESCRIPTION:
# Adds the specified dependencies, with use condition(s) to DEPEND (or
# BDEPEND in EAPI7), taking the current set of ruby targets into
# account. This makes sure that all ruby dependencies of the package are
# installed for the same ruby targets. Use this function for all ruby
# dependencies instead of setting DEPEND or BDEPEND yourself. The list
# of atoms uses the same syntax as normal dependencies.
ruby_add_bdepend() {
	debug-print-function ${FUNCNAME} "${@}"

	case $# in
		1) ;;
		2)
			case ${EAPI} in
				5|6)
					[[ "${GENTOO_DEV}" == "yes" ]] && eqawarn "You can now use the usual syntax in ruby_add_bdepend for $CATEGORY/$PF"
					ruby_add_bdepend "$(_ruby_wrap_conditions "$1" "$2")"
					return
					;;
				*)
					die "Use the usual depend syntax with a single argument in ruby_add_bdepend"
					;;
			esac
			;;
		*)
			die "bad number of arguments to $0"
			;;
	esac

	local dependency=$(_ruby_atoms_samelib "$1")

	case ${EAPI} in
		5|6) DEPEND="${DEPEND} $dependency" ;;
		*) BDEPEND="${BDEPEND} $dependency" ;;
	esac
	RDEPEND="${RDEPEND}"
}

# @FUNCTION: ruby_add_depend
# @USAGE: dependencies
# @DESCRIPTION:
# Adds the specified dependencies to DEPEND in EAPI7, similar to
# ruby_add_bdepend.
ruby_add_depend() {
	debug-print-function ${FUNCNAME} "${@}"

	case ${EAPI} in
		5|6) die "only available in EAPI 7 and newer" ;;
		*) ;;
	esac

	case $# in
		1) ;;
		*) die "bad number of arguments to $0" ;;
	esac

	local dependency=$(_ruby_atoms_samelib "$1")

	DEPEND="${DEPEND} $dependency"
}

# @FUNCTION: ruby_get_use_implementations
# @DESCRIPTION:
# Gets an array of ruby use targets enabled by the user
ruby_get_use_implementations() {
	debug-print-function ${FUNCNAME} "${@}"

	local i implementation
	for implementation in $(_ruby_get_all_impls); do
		use ruby_targets_${implementation} && i+=" ${implementation}"
	done
	echo $i
}

# @FUNCTION: ruby_get_use_targets
# @DESCRIPTION:
# Gets an array of ruby use targets that the ebuild sets
ruby_get_use_targets() {
	debug-print-function ${FUNCNAME} "${@}"

	local t implementation
	for implementation in $(_ruby_get_all_impls); do
		t+=" ruby_targets_${implementation}"
	done
	echo $t
}

# @FUNCTION: ruby_implementations_depend
# @RETURN: Dependencies suitable for injection into DEPEND and RDEPEND.
# @DESCRIPTION:
# Produces the dependency string for the various implementations of ruby
# which the package is being built against. This should not be used when
# RUBY_OPTIONAL is unset but must be used if RUBY_OPTIONAL=yes. Do not
# confuse this function with ruby_implementation_depend().
#
# @EXAMPLE:
# EAPI=7
# RUBY_OPTIONAL=yes
#
# inherit ruby-ng
# ...
# DEPEND="ruby? ( $(ruby_implementations_depend) )"
# RDEPEND="${DEPEND}"
ruby_implementations_depend() {
	debug-print-function ${FUNCNAME} "${@}"

	local depend
	for _ruby_implementation in $(_ruby_get_all_impls); do
		depend="${depend}${depend+ }ruby_targets_${_ruby_implementation}? ( $(ruby_implementation_depend $_ruby_implementation) )"
	done
	echo "${depend}"
}

IUSE+=" $(ruby_get_use_targets)"
# If you specify RUBY_OPTIONAL you also need to take care of
# ruby useflag and dependency.
if [[ ${RUBY_OPTIONAL} != yes ]]; then
	DEPEND="${DEPEND} $(ruby_implementations_depend)"
	RDEPEND="${RDEPEND} $(ruby_implementations_depend)"
	REQUIRED_USE+=" || ( $(ruby_get_use_targets) )"
	case ${EAPI} in
		5|6) ;;
		*) BDEPEND="${BDEPEND} $(ruby_implementations_depend)" ;;
	esac
fi

_ruby_invoke_environment() {
	old_S=${S}
	if [ -z "${RUBY_S}" ]; then
		sub_S=${P}
	else
		sub_S=${RUBY_S}
	fi

	# Special case, for the always-lovely GitHub fetches. With this,
	# we allow the star glob to just expand to whatever directory it's
	# called.
	if [[ "${sub_S}" = *"*"* ]]; then
		pushd "${WORKDIR}"/all &>/dev/null || die
		# use an array to trigger filename expansion
		# fun fact: this expansion fails in src_unpack() but the original
		# code did not have any checks for failed expansion, so we can't
		# really add one now without redesigning stuff hard.
		sub_S=( ${sub_S} )
		if [[ ${#sub_S[@]} -gt 1 ]]; then
			die "sub_S did expand to multiple paths: ${sub_S[*]}"
		fi
		popd &>/dev/null || die
	fi

	environment=$1; shift

	my_WORKDIR="${WORKDIR}"/${environment}
	S="${my_WORKDIR}"/"${sub_S}"

	if [[ -d "${S}" ]]; then
		pushd "$S" &>/dev/null || die
	elif [[ -d "${my_WORKDIR}" ]]; then
		pushd "${my_WORKDIR}" &>/dev/null || die
	else
		pushd "${WORKDIR}" &>/dev/null || die
	fi

	ebegin "Running ${_PHASE:-${EBUILD_PHASE}} phase for $environment"
	"$@"
	popd &>/dev/null || die

	S=${old_S}
}

_ruby_each_implementation() {
	local invoked=no
	for _ruby_implementation in $(_ruby_get_all_impls); do
		# only proceed if it's requested
		use ruby_targets_${_ruby_implementation} || continue

		RUBY=$(ruby_implementation_command ${_ruby_implementation})
		invoked=yes

		if [[ -n "$1" ]]; then
			_ruby_invoke_environment ${_ruby_implementation} "$@"
		fi

		unset RUBY
	done

	if [[ ${invoked} == "no" ]]; then
		eerror "You need to select at least one compatible Ruby installation target via RUBY_TARGETS in make.conf."
		eerror "Compatible targets for this package are: $(_ruby_get_all_impls)"
		eerror
		eerror "See https://www.gentoo.org/proj/en/prog_lang/ruby/index.xml#doc_chap3 for more information."
		eerror
		die "No compatible Ruby target selected."
	fi
}

# @FUNCTION: ruby-ng_pkg_setup
# @DESCRIPTION:
# Check whether at least one ruby target implementation is present.
ruby-ng_pkg_setup() {
	debug-print-function ${FUNCNAME} "${@}"

	# This only checks that at least one implementation is present
	# before doing anything; by leaving the parameters empty we know
	# it's a special case.
	_ruby_each_implementation
}

# @FUNCTION: ruby-ng_src_unpack
# @DESCRIPTION:
# Unpack the source archive.
ruby-ng_src_unpack() {
	debug-print-function ${FUNCNAME} "${@}"

	mkdir "${WORKDIR}"/all
	pushd "${WORKDIR}"/all &>/dev/null || die

	# We don't support an each-unpack, it's either all or nothing!
	if type all_ruby_unpack &>/dev/null; then
		_ruby_invoke_environment all all_ruby_unpack
	else
		[[ -n ${A} ]] && unpack ${A}
	fi

	popd &>/dev/null || die
}

_ruby_apply_patches() {
	case ${EAPI} in
		5)
			for patch in "${RUBY_PATCHES[@]}"; do
				if [ -f "${patch}" ]; then
					epatch "${patch}"
				elif [ -f "${FILESDIR}/${patch}" ]; then
					epatch "${FILESDIR}/${patch}"
				else
					die "Cannot find patch ${patch}"
				fi
			done
			;;
		6)
			if [[ -n ${RUBY_PATCHES[@]} ]]; then
			   eqawarn "RUBY_PATCHES is no longer supported, use PATCHES instead"
			fi
			;;
		*)
			if [[ -n ${RUBY_PATCHES[@]} ]]; then
				die "RUBY_PATCHES is no longer supported, use PATCHES instead"
			fi
			;;
	esac

	# This is a special case: instead of executing just in the special
	# "all" environment, this will actually copy the effects on _all_
	# the other environments, and is thus executed before the copy
	type all_ruby_prepare &>/dev/null && all_ruby_prepare
}

_ruby_source_copy() {
	# Until we actually find a reason not to, we use hardlinks, this
	# should reduce the amount of disk space that is wasted by this.
	cp -prlP all ${_ruby_implementation} \
		|| die "Unable to copy ${_ruby_implementation} environment"
}

# @FUNCTION: ruby-ng_src_prepare
# @DESCRIPTION:
# Apply patches and prepare versions for each ruby target
# implementation. Also carry out common clean up tasks.
ruby-ng_src_prepare() {
	debug-print-function ${FUNCNAME} "${@}"

	# Way too many Ruby packages are prepared on OSX without removing
	# the extra data forks, we do it here to avoid repeating it for
	# almost every other ebuild.
	find . -name '._*' -delete

	# Handle PATCHES and user supplied patches via the default phase
	case ${EAPI} in
		5)
			;;
		*)
			_ruby_invoke_environment all default
			;;
	esac

	_ruby_invoke_environment all _ruby_apply_patches

	_PHASE="source copy" \
		_ruby_each_implementation _ruby_source_copy

	if type each_ruby_prepare &>/dev/null; then
		_ruby_each_implementation each_ruby_prepare
	fi
}

# @FUNCTION: ruby-ng_src_configure
# @DESCRIPTION:
# Configure the package.
ruby-ng_src_configure() {
	debug-print-function ${FUNCNAME} "${@}"

	if type each_ruby_configure &>/dev/null; then
		_ruby_each_implementation each_ruby_configure
	fi

	type all_ruby_configure &>/dev/null && \
		_ruby_invoke_environment all all_ruby_configure
}

# @FUNCTION: ruby-ng_src_compile
# @DESCRIPTION:
# Compile the package.
ruby-ng_src_compile() {
	debug-print-function ${FUNCNAME} "${@}"

	if type each_ruby_compile &>/dev/null; then
		_ruby_each_implementation each_ruby_compile
	fi

	type all_ruby_compile &>/dev/null && \
		_ruby_invoke_environment all all_ruby_compile
}

# @FUNCTION: ruby-ng_src_test
# @DESCRIPTION:
# Run tests for the package.
ruby-ng_src_test() {
	debug-print-function ${FUNCNAME} "${@}"

	if type each_ruby_test &>/dev/null; then
		_ruby_each_implementation each_ruby_test
	fi

	type all_ruby_test &>/dev/null && \
		_ruby_invoke_environment all all_ruby_test
}

_each_ruby_check_install() {
	local scancmd=scanelf
	# we have a Mach-O object here
	[[ ${CHOST} == *-darwin ]] && scancmd=scanmacho

	local libruby_basename=$(ruby_rbconfig_value 'LIBRUBY_SO')
	local libruby_soname=$(basename $(${scancmd} -F "%S#F" -qS "${EPREFIX}/usr/$(get_libdir)/${libruby_basename}") 2>/dev/null)
	local sitedir=$(ruby_rbconfig_value 'sitedir')
	local sitelibdir=$(ruby_rbconfig_value 'sitelibdir')

	# The current implementation lacks libruby (i.e.: jruby)
	[[ -z ${libruby_soname} ]] && return 0

	# Check also the gems directory, since we could be installing compiled
	# extensions via ruby-fakegem; make sure to check only in sitelibdir, since
	# that's what changes between two implementations (otherwise you'd get false
	# positives now that Ruby 1.9.2 installs with the same sitedir as 1.8)
	${scancmd} -qnR "${D}${sitelibdir}" "${D}${sitelibdir/site_ruby/gems}" \
		| fgrep -v "${libruby_soname}" \
		| grep -E -v "${RUBY_QA_ALLOWED_LIBS}" \
		> "${T}"/ruby-ng-${_ruby_implementation}-mislink.log

	if [[ -s "${T}"/ruby-ng-${_ruby_implementation}-mislink.log ]]; then
		ewarn "Extensions installed for ${_ruby_implementation} with missing links to ${libruby_soname}"
		ewarn $(< "${T}"/ruby-ng-${_ruby_implementation}-mislink.log )
		die "Missing links to ${libruby_soname}"
	fi
}

# @FUNCTION: ruby-ng_src_install
# @DESCRIPTION:
# Install the package for each ruby target implementation.
ruby-ng_src_install() {
	debug-print-function ${FUNCNAME} "${@}"

	if type each_ruby_install &>/dev/null; then
		_ruby_each_implementation each_ruby_install
	fi

	type all_ruby_install &>/dev/null && \
		_ruby_invoke_environment all all_ruby_install

	_PHASE="check install" \
		_ruby_each_implementation _each_ruby_check_install
}

# @FUNCTION: ruby_rbconfig_value
# @USAGE: rbconfig item
# @RETURN: Returns the value of the given rbconfig item of the Ruby interpreter in ${RUBY}.
ruby_rbconfig_value() {
	debug-print-function ${FUNCNAME} "${@}"

	echo $(${RUBY} --disable=did_you_mean -rrbconfig -e "puts RbConfig::CONFIG['$1']" || die "Could not read ruby configuration for '${1}'")
}

# @FUNCTION: doruby
# @USAGE: file [file...]
# @DESCRIPTION:
# Installs the specified file(s) into the sitelibdir of the Ruby interpreter in ${RUBY}.
doruby() {
	debug-print-function ${FUNCNAME} "${@}"

	[[ -z ${RUBY} ]] && die "\$RUBY is not set"
	( # don't want to pollute calling env
		sitelibdir=$(ruby_rbconfig_value 'sitelibdir')
		insinto ${sitelibdir#${EPREFIX}}
		insopts -m 0644
		doins "$@"
	) || die "failed to install $@"
}

# @FUNCTION: ruby_get_libruby
# @RETURN: The location of libruby*.so belonging to the Ruby interpreter in ${RUBY}.
ruby_get_libruby() {
	debug-print-function ${FUNCNAME} "${@}"

	${RUBY} -rrbconfig -e 'puts File.join(RbConfig::CONFIG["libdir"], RbConfig::CONFIG["LIBRUBY"])'
}

# @FUNCTION: ruby_get_hdrdir
# @RETURN: The location of the header files belonging to the Ruby interpreter in ${RUBY}.
ruby_get_hdrdir() {
	debug-print-function ${FUNCNAME} "${@}"

	local rubyhdrdir=$(ruby_rbconfig_value 'rubyhdrdir')

	if [[ "${rubyhdrdir}" = "nil" ]] ; then
		rubyhdrdir=$(ruby_rbconfig_value 'archdir')
	fi

	echo "${rubyhdrdir}"
}

# @FUNCTION: ruby_get_version
# @RETURN: The version of the Ruby interpreter in ${RUBY}, or what 'ruby' points to.
ruby_get_version() {
	debug-print-function ${FUNCNAME} "${@}"

	local ruby=${RUBY:-$(type -p ruby 2>/dev/null)}

	echo $(${ruby} -e 'puts RUBY_VERSION')
}

# @FUNCTION: ruby_get_implementation
# @RETURN: The implementation of the Ruby interpreter in ${RUBY}, or what 'ruby' points to.
ruby_get_implementation() {
	debug-print-function ${FUNCNAME} "${@}"

	local ruby=${RUBY:-$(type -p ruby 2>/dev/null)}

	case $(${ruby} --version) in
		*rubinius*)
			echo "rbx"
			;;
		*)
			echo "mri"
			;;
	esac
}

# @FUNCTION: ruby-ng_rspec <arguments>
# @DESCRIPTION:
# This is simply a wrapper around the rspec command (executed by $RUBY})
# which also respects TEST_VERBOSE and NOCOLOR environment variables.
# Optionally takes arguments to pass on to the rspec invocation.  The
# environment variable RSPEC_VERSION can be used to control the specific
# rspec version that must be executed. It defaults to 2 for historical
# compatibility.
ruby-ng_rspec() {
	debug-print-function ${FUNCNAME} "${@}"

	local version=${RSPEC_VERSION-2}
	local files="$@"

	# Explicitly pass the expected spec directory since the versioned
	# rspec wrappers don't handle this automatically.
	if [ ${#@} -eq 0 ]; then
		files="spec"
	fi

	if [[ "${DEPEND}${BDEPEND}" != *"dev-ruby/rspec"* ]]; then
		ewarn "Missing test dependency dev-ruby/rspec"
	fi

	local rspec_params=
	case ${NOCOLOR} in
		1|yes|true)
			rspec_params+=" --no-color"
			;;
		*)
			rspec_params+=" --color"
			;;
	esac

	case ${TEST_VERBOSE} in
		1|yes|true)
			rspec_params+=" --format documentation"
			;;
		*)
			rspec_params+=" --format progress"
			;;
	esac

	${RUBY} -S rspec-${version} ${rspec_params} ${files} || die "rspec failed"
}

# @FUNCTION: ruby-ng_cucumber
# @DESCRIPTION:
# This is simply a wrapper around the cucumber command (executed by $RUBY})
# which also respects TEST_VERBOSE and NOCOLOR environment variables.
ruby-ng_cucumber() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ "${DEPEND}${BDEPEND}" != *"dev-util/cucumber"* ]]; then
		ewarn "Missing test dependency dev-util/cucumber"
	fi

	local cucumber_params=
	case ${NOCOLOR} in
		1|yes|true)
			cucumber_params+=" --no-color"
			;;
		*)
			cucumber_params+=" --color"
			;;
	esac

	case ${TEST_VERBOSE} in
		1|yes|true)
			cucumber_params+=" --format pretty"
			;;
		*)
			cucumber_params+=" --format progress"
			;;
	esac

	CUCUMBER_PUBLISH_QUIET=true ${RUBY} -S cucumber ${cucumber_params} "$@" || die "cucumber failed"
}

# @FUNCTION: ruby-ng_testrb-2
# @DESCRIPTION:
# This is simply a replacement for the testrb command that load the test
# files and execute them, with test-unit 2.x. This actually requires
# either an old test-unit-2 version or 2.5.1-r1 or later, as they remove
# their script and we installed a broken wrapper for a while.
# This also respects TEST_VERBOSE and NOCOLOR environment variables.
ruby-ng_testrb-2() {
	debug-print-function ${FUNCNAME} "${@}"

	if [[ "${DEPEND}${BDEPEND}" != *"dev-ruby/test-unit"* ]]; then
		ewarn "Missing test dependency dev-ruby/test-unit"
	fi

	local testrb_params=
	case ${NOCOLOR} in
		1|yes|true)
			testrb_params+=" --no-use-color"
			;;
		*)
			testrb_params+=" --use-color=auto"
			;;
	esac

	case ${TEST_VERBOSE} in
		1|yes|true)
			testrb_params+=" --verbose=verbose"
			;;
		*)
			testrb_params+=" --verbose=normal"
			;;
	esac

	${RUBY} -S testrb-2 ${testrb_params} "$@" || die "testrb-2 failed"
}
