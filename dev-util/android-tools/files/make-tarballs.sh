#!/bin/bash
# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# Create the various tarballs we need.  GoB does not provide stable archives (unlike github),
# and some repos are uselessly fat, so we have to create things by hand.  Fun times.

set -e

die() {
	echo "error: $*" >&2
	exit 1
}

fetch_boringssl() {
	local ver=$1 tag=$2
	local content hash

	echo "checking boringssl in ${tag}"
	content=$(wget -nv "https://android.googlesource.com/platform/external/boringssl/+/${tag}/BORINGSSL_REVISION?format=TEXT" -O -)
	hash=$(echo "${content}" | base64 -d)
	echo "using boringssl ${hash}"

	local tar="${DISTDIR}/boringssl-${hash}.tar.gz"
	if [[ ! -e ${tar} ]] ; then
		# We use github as it provides stable tarballs.  GoB does not (includes timestamps).
		# https://boringssl.googlesource.com/boringssl/+archive/${hash}.tar.gz
		wget -c "https://github.com/google/boringssl/archive/${hash}.tar.gz" -O "${tar}"
	fi

	du -h "${tar}"
}

# The extras repo has ballooned to ~200MB, so we have to strip the large useless
# files and random binaries.
fetch_extras() {
	local ver=$1 tag=$2
	local tar="${DISTDIR}/android-tools-${ver}-extras.tar.xz"

	if [[ ! -e ${tar} ]] ; then
		local prune=(
			ioshark
			memory_replay
			perfprofd
			simpleperf
		)
		local dir="${tag}-extras"
		rm -rf "${dir}"
		mkdir "${dir}"
		cd "${dir}"

		wget "https://android.googlesource.com/platform/system/extras/+archive/${tag}.tar.gz" -O extras.tar.gz
		tar xf extras.tar.gz
		rm -rf "${prune[@]}" extras.tar.gz

		cd ..
		tar cf - "${dir}" | xz -9 > "${dir}.tar.xz"
		rm -rf "${dir}"

		mv "${dir}.tar.xz" "${tar}"
	fi

	du -h "${tar}"
}

# Since the GoB archive is unstable, we might as well rewrite it into xz to shrink.
fetch_selinux() {
	local ver=$1 tag=$2
	local tar="${DISTDIR}/android-tools-${ver}-selinux.tar.xz"

	if [[ ! -e ${tar} ]] ; then
		wget "https://android.googlesource.com/platform/external/selinux/+archive/${tag}.tar.gz" -O - | zcat | xz > "${tar}"
	fi

	du -h "${tar}"
}

# Since the GoB archive is unstable, we might as well rewrite it into xz to shrink.
fetch_f2fs() {
	local ver=$1 tag=$2
	local tar="${DISTDIR}/android-tools-${ver}-f2fs-tools.tar.xz"

	if [[ ! -e ${tar} ]] ; then
		wget "https://android.googlesource.com/platform/external/f2fs-tools/+archive/${tag}.tar.gz" -O - | zcat | xz > "${tar}"
	fi

	du -h "${tar}"
}

usage() {
	local status=$1

	[[ ${status} -eq 1 ]] && exec 1>&2

	cat <<-EOF
	Usage: $0 <android version>

	To find the next available version, consult:
	https://git.archlinux.org/svntogit/community.git/log/trunk?h=packages/android-tools

	They have some helper scripts for building the files directly.

	Example:
	$0 android-8.1.0_r1
	EOF

	exit ${status}
}

main() {
	[[ $# -ne 1 ]] && usage 1
	[[ $1 == "-h" || $1 == "--help" ]] && usage 0

	if [[ -z ${DISTDIR} ]] ; then
		eval $(portageq -v envvar DISTDIR)
	fi
	if [[ -z ${DISTDIR} ]] ; then
		die "Please set \$DISTDIR first"
	fi

	local ver="${1#android-}"
	local tag="android-${ver}"
	fetch_boringssl "${ver}" "${tag}"
	fetch_extras "${ver}" "${tag}"
	fetch_selinux "${ver}" "${tag}"
	fetch_f2fs "${ver}" "${tag}"
}
main "$@"
