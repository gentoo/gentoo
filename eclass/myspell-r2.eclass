# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: myspell-r2.eclass
# @MAINTAINER:
# Conrad Kostecki <conikost@gentoo.org>
# @AUTHOR:
# Tomáš Chvátal <scarabeus@gentoo.org>
# @SUPPORTED_EAPIS: 7 8
# @BLURB: An eclass to streamline the construction of ebuilds for new Myspell dictionaries.
# @DESCRIPTION:
# The myspell-r2 eclass is designed to streamline the construction of ebuilds for
# the new Myspell dictionaries which support hunspell.

# @ECLASS_VARIABLE: MYSPELL_DICT
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array variable containing list of all dictionary files.
# @CODE
# MYSPELL_DICT=( "file.dic" "dir/file2.aff" )
# @CODE

# @ECLASS_VARIABLE: MYSPELL_HYPH
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array variable containing list of all hyphenation files.
# @CODE
# MYSPELL_HYPH=( "file.dic" "dir/file2.dic" )
# @CODE

# @ECLASS_VARIABLE: MYSPELL_THES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array variable containing list of all thesarus files.
# @CODE
# MYSPELL_THES=( "file.dat" "dir/file2.idx" )
# @CODE

case ${EAPI} in
	7|8)
		;;
	*)
		die "${ECLASS}: EAPI ${EAPI:-0} not supported"
		;;
esac

EXPORT_FUNCTIONS src_unpack src_install

# Basically no extra deps needed.
# Unzip is required for .oxt libreoffice extensions
# which are just fancy zip files.
BDEPEND="app-arch/unzip"

# by default this stuff does not have any folder in the pack
S="${WORKDIR}"

# @FUNCTION: myspell-r2_src_unpack
# @DESCRIPTION:
# Unpack all variants of weird stuff.
# In our case .oxt packs.
myspell-r2_src_unpack() {
	debug-print-function ${FUNCNAME} "$@"

	local f
	for f in ${A}; do
		case ${f} in
			*.oxt)
				echo ">>> Unpacking "${DISTDIR}/${f}" to ${PWD}"
				unzip -qoj "${DISTDIR}"/${f}
				assert "failed unpacking ${DISTDIR}/${f}"
				;;
			*) unpack ${f} ;;
		esac
	done
}

# @FUNCTION: myspell-r2_src_install
# @DESCRIPTION:
# Install the dictionaries to the right places.
myspell-r2_src_install() {
	debug-print-function ${FUNCNAME} "$@"

	local x target

	# Following the debian directory layout here.
	# DICT: /usr/share/hunspell
	# THES: /usr/share/mythes
	# HYPH: /usr/share/hyphen
	# We just need to copy the required files to proper places.

	# TODO: backcompat dosym remove when all dictionaries and libreoffice
	#       ebuilds in tree use only the new paths

	# Very old installs have hunspell to be symlink to myspell.
	# This results in fcked up install/symlink stuff.
	if [[ -L "${EPREFIX}/usr/share/hunspell" ]] ; then
		eerror "\"${EPREFIX}/usr/share/hunspell\" is a symlink."
		eerror "Please remove it so it is created properly as folder"
		die "\"${EPREFIX}/usr/share/hunspell\" is a symlink."
	fi

	insinto /usr/share/hunspell
	for x in "${MYSPELL_DICT[@]}"; do
		target="${x##*/}"
		newins "${x}" "${target}" || die
		dosym ../hunspell/"${target}" /usr/share/myspell/"${target}" || die
	done

	insinto /usr/share/mythes
	for x in "${MYSPELL_THES[@]}"; do
		target="${x##*/}"
		newins "${x}" "${target}" || die
		dosym ../mythes/"${target}" /usr/share/myspell/"${target}" || die
	done

	insinto /usr/share/hyphen
	for x in "${MYSPELL_HYPH[@]}"; do
		target="${x##*/}"
		newins "${x}" "${target}" || die
		dosym ../hyphen/"${target}" /usr/share/myspell/"${target}" || die
	done

	# Remove licenses as they suffix them with .txt too
	rm -rf COPYING*
	rm -rf LICENSE*
	rm -rf LICENCE*
	rm -rf license*
	rm -rf licence*
	# Readme and so on
	for x in *.txt README*; do
		if [[ -f ${x} ]]; then
			dodoc ${x} || die
		fi
	done
}
