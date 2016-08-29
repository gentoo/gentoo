# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: cargo.eclass
# @MAINTAINER:
# rust@gentoo.org
# @AUTHOR:
# Doug Goldstein <cardoe@gentoo.org>
# @BLURB: common functions and variables for cargo builds

if [[ -z ${_CARGO_ECLASS} ]]; then
_CARGO_ECLASS=1

case ${EAPI} in
	6) : ;;
	*) die "EAPI=${EAPI:-0} is not supported" ;;
esac

EXPORT_FUNCTIONS src_unpack

ECARGO_HOME="${WORKDIR}/cargo_home"
ECARGO_REPO="github.com-88ac128001ac3a9a"
ECARGO_INDEX="${ECARGO_HOME}/registry/index/${ECARGO_REPO}"
ECARGO_SRC="${ECARGO_HOME}/registry/src/${ECARGO_REPO}"
ECARGO_CACHE="${ECARGO_HOME}/registry/cache/${ECARGO_REPO}"

# @FUNCTION: cargo_crate_uris
# @DESCRIPTION:
# Generates the URIs to put in SRC_URI to help fetch dependencies.
cargo_crate_uris() {
	for crate in $*; do
		local name version url
		name="${crate%-*}"
		version="${crate##*-}"
		url="https://crates.io/api/v1/crates/${name}/${version}/download -> ${crate}.crate"
		echo $url
	done
}

# @FUNCTION: cargo_src_unpack
# @DESCRIPTION:
# Unpacks the package and the cargo registry
cargo_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	mkdir -p "${ECARGO_INDEX}" || die
	mkdir -p "${ECARGO_CACHE}" || die
	mkdir -p "${ECARGO_SRC}" || die
	mkdir -p "${S}" || die

	local archive
	for archive in ${A}; do
		case "${archive}" in
			*.crate)
				ebegin "Unpacking ${archive}"
				cp "${DISTDIR}"/${archive} "${ECARGO_CACHE}/" || die
				tar -xf "${DISTDIR}"/${archive} -C "${ECARGO_SRC}/" || die
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
			cargo-registry*)
				ebegin "Unpacking ${archive}"
				tar -xzf "${DISTDIR}"/${archive} -C "${ECARGO_INDEX}" --strip-components 1 || die
				# prevent cargo from attempting to download this again
				touch "${ECARGO_INDEX}"/.cargo-index-lock || die
				eend $?
				;;
			*)
				unpack ${archive}
				;;
		esac
	done
}


fi
