# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: office-ext-r1.eclass
# @MAINTAINER:
# The office team <office@gentoo.org>
# @AUTHOR:
# Tomáš Chvátal <scarabeus@gentoo.org>
# @SUPPORTED_EAPIS: 5 7
# @BLURB: Eclass for installing libreoffice extensions
# @DESCRIPTION:
# Eclass for easing maintenance of libreoffice extensions.

case "${EAPI:-0}" in
	5) inherit eutils multilib ;;
	7) inherit eutils ;;
	*) die "EAPI=${EAPI} is not supported" ;;
esac

EXPORT_FUNCTIONS src_unpack src_install

# @ECLASS-VARIABLE: OFFICE_REQ_USE
# @PRE_INHERIT
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
# OFFICE_IMPLEMENTATIONS=( "libreoffice" )
# @CODE
[[ -z ${OFFICE_IMPLEMENTATIONS} ]] && OFFICE_IMPLEMENTATIONS=( "libreoffice" )

# @ECLASS-VARIABLE: OFFICE_EXTENSIONS
# @PRE_INHERIT
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
	if [[ ${i} == "libreoffice" ]]; then
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
					mkdir -p "${WORKDIR}/${i}/" || die
					pushd "${WORKDIR}/${i}/" > /dev/null || die
					einfo "Unpacking "${OFFICE_EXTENSIONS_LOCATION}/${i}" to ${PWD}"
					unzip -qo ${OFFICE_EXTENSIONS_LOCATION}/${i}
					assert "failed unpacking ${OFFICE_EXTENSIONS_LOCATION}/${i}"
					popd > /dev/null || die
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
			for j in ${OFFICE_EXTENSIONS[@]}; do
				pushd "${WORKDIR}/${j}/" > /dev/null || die
				insinto /usr/$(get_libdir)/${i}/share/extensions/${j/.oxt/}
				doins -r *
				popd > /dev/null || die
			done
		fi
	done
}
