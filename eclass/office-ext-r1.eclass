# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: office-ext-r1.eclass
# @MAINTAINER:
# The office team <openoffice@gentoo.org>
# @AUTHOR:
# Tomáš Chvátal <scarabeus@gentoo.org>
# @BLURB: Eclass for installing libreoffice/openoffice extensions
# @DESCRIPTION:
# Eclass for easing maitenance of libreoffice/openoffice extensions.

case "${EAPI:-0}" in
	5) OEXT_EXPORTED_FUNCTIONS="src_unpack src_install pkg_postinst pkg_prerm" ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

inherit eutils multilib

# @ECLASS-VARIABLE: OFFICE_REQ_USE
# @DESCRIPTION:
# Useflags required on office implementation for the extension.
#
# Example:
# @CODE
# OFFICE_REQ_USE="java,jemalloc(-)?"
# @CODE
if [[ ${OFFICE_REQ_USE} ]]; then
	# Append the brackets for the depend bellow
	OFFICE_REQ_USE="[${OFFICE_REQ_USE}]"
fi

# @ECLASS-VARIABLE: OFFICE_IMPLEMENTATIONS
# @DESCRIPTION:
# List of implementations supported by the extension.
# Some work only for libreoffice and vice versa.
# Default value is all implementations.
#
# Example:
# @CODE
# OFFICE_IMPLEMENTATIONS=( "libreoffice" "openoffice" )
# @CODE
[[ -z ${OFFICE_IMPLEMENTATIONS} ]] && OFFICE_IMPLEMENTATIONS=( "libreoffice" "openoffice" )

# @ECLASS-VARIABLE: OFFICE_EXTENSIONS
# @REQUIRED
# @DESCRIPTION:
# Array containing list of extensions to install.
#
# Example:
# @CODE
# OFFICE_EXTENSIONS=( ${PN}_${PV}.oxt )
# @CODE
[[ -z ${OFFICE_EXTENSIONS} ]] && die "OFFICE_EXTENSIONS variable is unset."
if [[ "$(declare -p OFFICE_EXTENSIONS 2>/dev/null 2>&1)" != "declare -a"* ]]; then
	die "OFFICE_EXTENSIONS variable is not an array."
fi

# @ECLASS-VARIABLE: OFFICE_EXTENSIONS_LOCATION
# @DESCRIPTION:
# Path to the extensions location. Defaults to ${DISTDIR}.
#
# Example:
# @CODE
# OFFICE_EXTENSIONS_LOCATION="${S}/unpacked/"
# @CODE
: ${OFFICE_EXTENSIONS_LOCATION:=${DISTDIR}}

IUSE=""
RDEPEND=""

for i in ${OFFICE_IMPLEMENTATIONS[@]}; do
	IUSE+=" office_implementation_${i}"
	if [[ ${i} == "openoffice" ]]; then
		# special only binary
		RDEPEND+="
			office_implementation_openoffice? (
				app-office/openoffice-bin${OFFICE_REQ_USE}
			)
		"
	else
		RDEPEND+="
			office_implementation_${i}? (
				|| (
					app-office/${i}${OFFICE_REQ_USE}
					app-office/${i}-bin${OFFICE_REQ_USE}
				)
			)
		"
	fi
done

REQUIRED_USE="|| ( "
for i in ${OFFICE_IMPLEMENTATIONS[@]}; do
	REQUIRED_USE+=" office_implementation_${i} "
done
REQUIRED_USE+=" )"

DEPEND="${RDEPEND}
	app-arch/unzip
"

# Most projects actually do not provide any relevant sourcedir as they are oxt.
S="${WORKDIR}"

# @FUNCTION: office-ext-r1_src_unpack
# @DESCRIPTION:
# Flush the cache after removal of an extension.
office-ext-r1_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"
	local i

	default

	for i in ${OFFICE_EXTENSIONS[@]}; do
		# Unpack the extensions where required and add case for oxt
		# which should be most common case for the extensions.
		if [[ -f "${OFFICE_EXTENSIONS_LOCATION}/${i}" ]] ; then
			case ${i} in
				*.oxt)
					mkdir -p "${WORKDIR}/${i}/"
					pushd "${WORKDIR}/${i}/" > /dev/null
					echo ">>> Unpacking "${OFFICE_EXTENSIONS_LOCATION}/${i}" to ${PWD}"
					unzip -qo ${OFFICE_EXTENSIONS_LOCATION}/${i}
					assert "failed unpacking ${OFFICE_EXTENSIONS_LOCATION}/${i}"
					popd > /dev/null
					;;
				*) unpack ${i} ;;
			esac
		fi
	done
}

# @FUNCTION: office-ext-r1_src_install
# @DESCRIPTION:
# Install the extension source to the proper location.
office-ext-r1_src_install() {
	debug-print-function ${FUNCNAME} "$@"
	debug-print "Extensions: ${OFFICE_EXTENSIONS[@]}"

	local i j

	for i in ${OFFICE_IMPLEMENTATIONS[@]}; do
		if use office_implementation_${i}; then
			if [[ ${i} == openoffice ]]; then
				# OOO needs to use uno because direct deployment segfaults.
				# This is bug by their side, but i don't want to waste time
				# fixing it myself.
				insinto /usr/$(get_libdir)/${i}/share/extension/install
				for j in ${OFFICE_EXTENSIONS[@]}; do
					doins ${OFFICE_EXTENSIONS_LOCATION}/${j}
				done
			else
				for j in ${OFFICE_EXTENSIONS[@]}; do
					pushd "${WORKDIR}/${j}/" > /dev/null
					insinto /usr/$(get_libdir)/${i}/share/extensions/${j/.oxt/}
					doins -r *
					popd > /dev/null
				done
			fi
		fi
	done
}

#### OPENOFFICE COMPAT CODE

UNOPKG_BINARY="/usr/lib64/openoffice/program/unopkg"

# @FUNCTION: office-ext-r1_add_extension
# @DESCRIPTION:
# Install the extension into the libreoffice/openoffice.
office-ext-r1_add_extension() {
	debug-print-function ${FUNCNAME} "$@"
	local ext=$1
	local tmpdir=$(emktemp -d)

	debug-print "${FUNCNAME}: ${UNOPKG_BINARY} add --shared \"${ext}\""
	ebegin "Adding office extension: \"${ext}\""
	${UNOPKG_BINARY} add --suppress-license \
		--shared "${ext}" \
		"-env:UserInstallation=file:///${tmpdir}" \
		"-env:JFW_PLUGIN_DO_NOT_CHECK_ACCESSIBILITY=1"
	eend $?
	${UNOPKG_BINARY} list --shared > /dev/null
	rm -rf "${tmpdir}"
}

# @FUNCTION: office-ext-r1_remove_extension
# @DESCRIPTION:
# Remove the extension from the libreoffice/openoffice.
office-ext-r1_remove_extension() {
	debug-print-function ${FUNCNAME} "$@"
	local ext=$1
	local tmpdir=$(mktemp -d --tmpdir="${T}")

	debug-print "${FUNCNAME}: ${UNOPKG_BINARY} remove --shared \"${ext}\""
	ebegin "Removing office extension: \"${ext}\""
	${UNOPKG_BINARY} remove --suppress-license \
		--shared "${ext}" \
		"-env:UserInstallation=file:///${tmpdir}" \
		"-env:JFW_PLUGIN_DO_NOT_CHECK_ACCESSIBILITY=1"
	eend $?
	${UNOPKG_BINARY} list --shared > /dev/null
	rm -rf "${tmpdir}"
}

# @FUNCTION: office-ext-r1_pkg_postinst
# @DESCRIPTION:
# Add the extensions to the openoffice.
office-ext-r1_pkg_postinst() {
	if in_iuse office_implementation_openoffice && use office_implementation_openoffice; then
		debug-print-function ${FUNCNAME} "$@"
		debug-print "Extensions: ${OFFICE_EXTENSIONS[@]}"
		local i

		for i in ${OFFICE_EXTENSIONS[@]}; do
			office-ext-r1_add_extension "/usr/lib64/openoffice/share/extension/install/${i}"
		done
	fi
}

# @FUNCTION: office-ext-r1_pkg_prerm
# @DESCRIPTION:
# Remove the extensions from the openoffice.
office-ext-r1_pkg_prerm() {
	if in_iuse office_implementation_openoffice && use office_implementation_openoffice; then
		debug-print-function ${FUNCNAME} "$@"
		debug-print "Extensions: ${OFFICE_EXTENSIONS[@]}"
		local i

		for i in ${OFFICE_EXTENSIONS[@]}; do
			office-ext-r1_remove_extension "${i}"
		done
	fi
}

EXPORT_FUNCTIONS ${OEXT_EXPORTED_FUNCTIONS}
unset OEXT_EXPORTED_FUNCTIONS
