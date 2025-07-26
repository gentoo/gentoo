# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: greadme.eclass
# @MAINTAINER:
# Florian Schmaus <flow@gentoo.org>
# @SUPPORTED_EAPIS: 8
# @BLURB: install a doc file, that will be conditionally shown via elog messages
# @DESCRIPTION:
# An eclass for installing a README.gentoo doc file with important
# information for the user.  The content of README.gentoo will shown be
# via elog messages either on fresh installations or if the contents of
# the file have changed.  Furthermore, the README.gentoo file will be
# installed under /usr/share/doc/${PF} for later consultation.
#
# This eclass was inspired by readme.gentoo-r1.eclass.  The main
# differences are as follows.  Firstly, it only displays the doc file
# contents if they have changed (unless GREADME_SHOW is set).
# Secondly, it provides a convenient API to install the doc file via
# stdin.
#
# @CODE
# inherit greadme
#
# src_install() {
#   ...
#   greadme_stdin <<-EOF
#   This is the content of the created readme doc file.
#   EOF
#   ...
#   if use foo; then
#     greadme_stdin --append <<-EOF
#     This is conditional readme content, based on USE=foo.
#     EOF
#   fi
# }
# @CODE
#
# If the ebuild overrides the default pkg_preinst or respectively
# pkg_postinst, then it must call greadme_pkg_preinst and
# greadme_pkg_postinst explicitly.

if [[ -z ${_GREADME_ECLASS} ]]; then
_GREADME_ECLASS=1

case ${EAPI} in
	8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

_GREADME_TMP_FILE="${T}/README.gentoo"
_GREADME_REL_PATH="/usr/share/doc/${PF}/README.gentoo"

# @ECLASS_VARIABLE: GREADME_SHOW
# @DEFAULT_UNSET
# @DESCRIPTION:
# If set to "yes" then unconditionally show the contents of the readme
# file in pkg_postinst via elog. If set to "no", then do not show the
# contents of the readme file, even if they have changed.

# @ECLASS_VARIABLE: GREADME_DISABLE_AUTOFORMAT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If non-empty, the readme file will not be automatically formatted.

# @FUNCTION: greadme_stdin
# @USAGE: [--append]
# @DESCRIPTION:
# Create the readme doc via stdin.  You can use --append to append to an
# existing readme doc.
greadme_stdin() {
	debug-print-function ${FUNCNAME} "$@"

	local append
	if [[ ${1} = --append ]]; then
		append=1
		shift
	fi

	[[ $# -eq 0 ]] || die "${FUNCNAME[0]}: Bad parameters: $*"

	if [[ -n ${append} ]]; then
		cat >> "${_GREADME_TMP_FILE}" || die
	else
		cat > "${_GREADME_TMP_FILE}" || die
	fi

	_greadme_install_doc
}

# @FUNCTION: greadme_file
# @USAGE: <file>
# @DESCRIPTION:
# Installs the provided file as readme doc.
greadme_file() {
	debug-print-function ${FUNCNAME} "$@"

	local input_doc_file="${1}"
	if [[ -z ${input_doc_file} ]]; then
		die "No file specified"
	fi

	cp "${input_doc_file}" "${_GREADME_TMP_FILE}" || die

	_greadme_install_doc
}

# @FUNCTION: _greadme_install_doc
# @INTERNAL
# @DESCRIPTION:
# Installs the readme file from the temp directory into the image.
_greadme_install_doc() {
	debug-print-function ${FUNCNAME} "$@"

	local greadme="${_GREADME_TMP_FILE}"
	if [[ ! ${GREADME_DISABLE_AUTOFORMAT} ]]; then
		greadme="${_GREADME_TMP_FILE}".formatted

		# Use fold, followed by a sed to strip trailing whitespace.
		# https://bugs.gentoo.org/460050#c7
		fold -s -w 70 "${_GREADME_TMP_FILE}" |
			sed 's/[[:space:]]*$//' > "${greadme}"
		assert "failed to autoformat README.gentoo"
	fi

	# Subshell to avoid pollution of calling environment.
	(
		docinto .
		newdoc "${greadme}" "README.gentoo"
	)

	# Exclude the readme file from compression, so that its contents can
	# be easily compared.
	docompress -x "${_GREADME_REL_PATH}"

	# Save the contents of the of the readme. Unfortunately we have to
	# do this in src_* phase, because FEATURES=nodoc is applied right
	# after src_install and not after pkg_preinst.
	_GREADME_CONTENT=$(< "${greadme}")
}

# @FUNCTION: greadme_pkg_preinst
# @DESCRIPTION:
# Performs checks like comparing the readme doc from the image with a
# potentially existing one in the live system.
greadme_pkg_preinst() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ -z ${REPLACING_VERSIONS} ]]; then
		_GREADME_SHOW="fresh-install"
		return
	fi

	if [[ -v GREADME_SHOW ]]; then
		case ${GREADME_SHOW} in
			yes)
				_GREADME_SHOW="forced"
				;;
			no)
				_GREADME_SHOW=""
				;;
			*)
				die "Invalid argument of GREADME_SHOW: ${GREADME_SHOW}"
				;;
		esac
		return
	fi

	local image_greadme_file="${ED}${_GREADME_REL_PATH}"
	if [[ ! -f ${image_greadme_file} ]]; then
		if [[ -v _GREADME_CONTENT ]]; then
			# There is no greadme in the image but the ebuild created
			# one. This is likely because FEATURES=nodoc is active.
			# Unconditionally show greadme's contents.
			_GREADME_SHOW="nodoc-active"
		else
			# No README file was created by the ebuild.
			_GREADME_SHOW=""
		fi

		return
	fi

	check_live_doc_file() {
		local cur_pvr=$1
		local live_greadme_file="${EROOT}/usr/share/doc/${PN}-${cur_pvr}/README.gentoo"

		if [[ ! -f ${live_greadme_file} ]]; then
			_GREADME_SHOW="no-current-greadme"
			return
		fi

		cmp -s "${live_greadme_file}" "${image_greadme_file}"
		case $? in
			0)
				_GREADME_SHOW=""
				;;
			1)
				_GREADME_SHOW="content-differs"
				;;
			*)
				die "cmp failed with $?"
				;;
		esac
	}

	local replaced_version
	for replaced_version in ${REPLACING_VERSIONS}; do
		check_live_doc_file ${replaced_version}

		# Once _GREADME_SHOW is non empty, we found a reason to show the
		# readme and we can abort the loop.
		if [[ -n ${_GREADME_SHOW} ]]; then
			break
		fi
	done
}

# @FUNCTION: greadme_pkg_postinst
# @DESCRIPTION:
# Conditionally shows the contents of the readme doc via elog.
greadme_pkg_postinst() {
	debug-print-function ${FUNCNAME} "$@"

	if [[ ! -v _GREADME_SHOW ]]; then
		die "_GREADME_SHOW not set. Did you call greadme_pkg_preinst?"
	fi

	if [[ -z ${_GREADME_SHOW} ]]; then
		# If _GREADME_SHOW is empty, then there is no reason to show the contents.
		return
	fi

	local line
	printf '%s\n' "${_GREADME_CONTENT}" | while read -r line; do
		elog "${line}"
	done
	elog ""
	elog "NOTE: Above message is only printed the first time package is"
	elog "installed or if the message changed. Please look at"
	elog "${EPREFIX}${_GREADME_REL_PATH}"
	elog "for future reference."
}

fi

EXPORT_FUNCTIONS pkg_preinst pkg_postinst
