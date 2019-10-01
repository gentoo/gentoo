# Copyright 1999-2019 Jason Zaman
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: bazel.eclass
# @MAINTAINER:
# Jason Zaman <perfinion@gentoo.org>
# @AUTHOR:
# Jason Zaman <perfinion@gentoo.org>
# @SUPPORTED_EAPIS: 7
# @BLURB: Utility functions for packages using Bazel Build
# @DESCRIPTION:
# A utility eclass providing functions to run the Bazel Build system.
#
# This eclass does not export any phase functions.

case "${EAPI:-0}" in
	0|1|2|3|4|5|6)
		die "Unsupported EAPI=${EAPI:-0} (too old) for ${ECLASS}"
		;;
	7)
		;;
	*)
		die "Unsupported EAPI=${EAPI} (unknown) for ${ECLASS}"
		;;
esac

if [[ ! ${_BAZEL_ECLASS} ]]; then

inherit multiprocessing toolchain-funcs

BDEPEND=">=dev-util/bazel-0.20"

# @FUNCTION: bazel_get_flags
# @DESCRIPTION:
# Obtain and print the bazel flags for target and host *FLAGS.
#
# To add more flags to this, append the flags to the
# appropriate variable before calling this function
bazel_get_flags() {
	local i fs=()
	for i in ${CFLAGS}; do
		fs+=( "--conlyopt=${i}" )
	done
	for i in ${BUILD_CFLAGS}; do
		fs+=( "--host_conlyopt=${i}" )
	done
	for i in ${CXXFLAGS}; do
		fs+=( "--cxxopt=${i}" )
	done
	for i in ${BUILD_CXXFLAGS}; do
		fs+=( "--host_cxxopt=${i}" )
	done
	for i in ${CPPFLAGS}; do
		fs+=( "--conlyopt=${i}" "--cxxopt=${i}" )
	done
	for i in ${BUILD_CPPFLAGS}; do
		fs+=( "--host_conlyopt=${i}" "--host_cxxopt=${i}" )
	done
	for i in ${LDFLAGS}; do
		fs+=( "--linkopt=${i}" )
	done
	for i in ${BUILD_LDFLAGS}; do
		fs+=( "--host_linkopt=${i}" )
	done
	echo "${fs[*]}"
}

# @FUNCTION: bazel_setup_bazelrc
# @DESCRIPTION:
# Creates the bazelrc with common options that will be passed
# to bazel. This will be called by ebazel automatically so
# does not need to be called from the ebuild.
bazel_setup_bazelrc() {
	if [[ -f "${T}/bazelrc" ]]; then
		return
	fi

	# F: fopen_wr
	# P: /proc/self/setgroups
	# Even with standalone enabled, the Bazel sandbox binary is run for feature test:
	# https://github.com/bazelbuild/bazel/blob/7b091c1397a82258e26ab5336df6c8dae1d97384/src/main/java/com/google/devtools/build/lib/sandbox/LinuxSandboxedSpawnRunner.java#L61
	# https://github.com/bazelbuild/bazel/blob/76555482873ffcf1d32fb40106f89231b37f850a/src/main/tools/linux-sandbox-pid1.cc#L113
	addpredict /proc

	mkdir -p "${T}/bazel-cache" || die
	mkdir -p "${T}/bazel-distdir" || die

	cat > "${T}/bazelrc" <<-EOF || die
		startup --batch

		# dont strip HOME, portage sets a temp per-package dir
		build --action_env HOME

		# make bazel respect MAKEOPTS
		build --jobs=$(makeopts_jobs)
		build --compilation_mode=opt --host_compilation_mode=opt

		# FLAGS
		build $(bazel_get_flags)

		# Use standalone strategy to deactivate the bazel sandbox, since it
		# conflicts with FEATURES=sandbox.
		build --spawn_strategy=standalone --genrule_strategy=standalone
		test --spawn_strategy=standalone --genrule_strategy=standalone

		build --strip=never
		build --verbose_failures --noshow_loading_progress
		test --verbose_test_summary --verbose_failures --noshow_loading_progress

		# make bazel only fetch distfiles from the cache
		fetch --repository_cache="${T}/bazel-cache/" --distdir="${T}/bazel-distdir/"
		build --repository_cache="${T}/bazel-cache/" --distdir="${T}/bazel-distdir/"

		build --define=PREFIX=${EPREFIX%/}/usr
		build --define=LIBDIR=\$(PREFIX)/$(get_libdir)
		EOF

	if tc-is-cross-compiler; then
		echo "build --nodistinct_host_configuration" >> "${T}/bazelrc" || die
	fi
}

# @FUNCTION: ebazel
# @USAGE: [<args>...]
# @DESCRIPTION:
# Run bazel with the bazelrc and output_base.
#
# output_base will be specific to $BUILD_DIR (if unset, $S).
# bazel_setup_bazelrc will be called and the created bazelrc
# will be passed to bazel.
#
# Will automatically die if bazel does not exit cleanly.
ebazel() {
	bazel_setup_bazelrc

	# Use different build folders for each multibuild variant.
	local output_base="${BUILD_DIR:-${S}}"
	output_base="${output_base%/}-bazel-base"
	mkdir -p "${output_base}" || die

	set -- bazel --bazelrc="${T}/bazelrc" --output_base="${output_base}" ${@}
	echo "${*}" >&2
	"${@}" || die "ebazel failed"
}

# @FUNCTION: bazel_load_distfiles
# @USAGE: <distfiles>...
# @DESCRIPTION:
# Populate the bazel distdir to fetch from since it cannot use
# the network. Bazel looks in distdir but will only look for the
# original filename, not the possibly renamed one that portage
# downloaded. If the line has -> we to rename it back. This also
# handles use-conditionals that SRC_URI does.
#
# Example:
# @CODE
# bazel_external_uris="http://a/file-2.0.tgz
#     python? ( http://b/1.0.tgz -> foo-1.0.tgz )"
# SRC_URI="http://c/${PV}.tgz
#     ${bazel_external_uris}"
#
# src_unpack() {
#     unpack ${PV}.tgz
#     bazel_load_distfiles "${bazel_external_uris}"
# }
# @CODE
bazel_load_distfiles() {
	local file=""
	local rename=0

	[[ "${@}" ]] || die "Missing args"
	mkdir -p "${T}/bazel-distdir" || die

	for word in ${@}
	do
		if [[ "${word}" == "->" ]]; then
			# next word is a dest filename
			rename=1
		elif [[ "${word}" == ")" ]]; then
			# close conditional block
			continue
		elif [[ "${word}" == "(" ]]; then
			# open conditional block
			continue
		elif [[ "${word}" == ?(\!)[A-Za-z0-9]*([A-Za-z0-9+_@-])\? ]]; then
			# use-conditional block
			# USE-flags can contain [A-Za-z0-9+_@-], and start with alphanum
			# https://dev.gentoo.org/~ulm/pms/head/pms.html#x1-200003.1.4
			# ?(\!) matches zero-or-one !'s
			# *(...) zero-or-more characters
			# ends with a ?
			continue
		elif [[ ${rename} -eq 1 ]]; then
			# Make sure the distfile is used
			if [[ "${A}" == *"${word}"* ]]; then
				echo "Copying ${word} to bazel distdir as ${file}"
				ln -s "${DISTDIR}/${word}" "${T}/bazel-distdir/${file}" || die
			fi
			rename=0
			file=""
		else
			# another URL, current one may or may not be a rename
			# if there was a previous one, its not renamed so copy it now
			if [[ -n "${file}" && "${A}" == *"${file}"* ]]; then
				echo "Copying ${file} to bazel distdir"
				ln -s "${DISTDIR}/${file}" "${T}/bazel-distdir/${file}" || die
			fi
			# save the current URL, later we will find out if its a rename or not.
			file="${word##*/}"
		fi
	done

	# handle last file
	if [[ -n "${file}" ]]; then
		echo "Copying ${file} to bazel distdir"
		ln -s "${DISTDIR}/${file}" "${T}/bazel-distdir/${file}" || die
	fi
}

_BAZEL_ECLASS=1
fi
