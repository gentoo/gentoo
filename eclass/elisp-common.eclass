# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
#
# @ECLASS: elisp-common.eclass
# @MAINTAINER:
# Gentoo GNU Emacs project <gnu-emacs@gentoo.org>
# @AUTHOR:
# Matthew Kennedy <mkennedy@gentoo.org>
# Jeremy Maitin-Shepard <jbms@attbi.com>
# Mamoru Komachi <usata@gentoo.org>
# Christian Faulhammer <fauli@gentoo.org>
# Ulrich Müller <ulm@gentoo.org>
# @BLURB: Emacs-related installation utilities
# @DESCRIPTION:
#
# Usually you want to use this eclass for (optional) GNU Emacs support
# of your package.  This is NOT for XEmacs!
#
# Many of the steps here are sometimes done by the build system of your
# package (especially compilation), so this is mainly for standalone
# elisp files you gathered from somewhere else.
#
# When relying on the emacs USE flag, you need to add
#
# @CODE
# 	emacs? ( virtual/emacs )
# @CODE
#
# to your DEPEND/RDEPEND line and use the functions provided here to
# bring the files to the correct locations.
#
# If your package requires a minimum Emacs version, e.g. Emacs 24, then
# the dependency should be on >=virtual/emacs-24 instead.  Because the
# user can select the Emacs executable with eselect, you should also
# make sure that the active Emacs version is sufficient.  This can be
# tested with function elisp-need-emacs(), which would typically be
# called from pkg_setup(), as in the following example:
#
# @CODE
# 	elisp-need-emacs 24 || die "Emacs version too low"
# @CODE
#
# Please note that such tests should be limited to packages that are
# known to fail with lower Emacs versions; the standard case is to
# depend on virtual/emacs without version.
#
# @ROFF .SS
# src_compile() usage:
#
# An elisp file is compiled by the elisp-compile() function defined
# here and simply takes the source files as arguments.  The case of
# interdependent elisp files is also supported, since the current
# directory is added to the load-path which makes sure that all files
# are loadable.
#
# @CODE
# 	elisp-compile *.el
# @CODE
#
# Function elisp-make-autoload-file() can be used to generate a file
# with autoload definitions for the lisp functions.  It takes the output
# file name (default: "${PN}-autoloads.el") and a list of directories
# (default: working directory) as its arguments.  Use of this function
# requires that the elisp source files contain magic ";;;###autoload"
# comments.  See the Emacs Lisp Reference Manual (node "Autoload") for
# a detailed explanation.
#
# @ROFF .SS
# src_install() usage:
#
# The resulting compiled files (.elc) should be put in a subdirectory of
# /usr/share/emacs/site-lisp/ which is named after the first argument
# of elisp-install().  The following parameters are the files to be put
# in that directory.  Usually the subdirectory should be ${PN}, you can
# choose something else, but remember to tell elisp-site-file-install()
# (see below) the change, as it defaults to ${PN}.
#
# @CODE
# 	elisp-install ${PN} *.el *.elc
# @CODE
#
# To let the Emacs support be activated by Emacs on startup, you need
# to provide a site file (shipped in ${FILESDIR}) which contains the
# startup code (have a look in the documentation of your software).
# Normally this would look like this:
#
# @CODE
# 	(add-to-list 'load-path "@SITELISP@")
# 	(add-to-list 'auto-mode-alist '("\\.csv\\'" . csv-mode))
# 	(autoload 'csv-mode "csv-mode" "Major mode for csv files." t)
# @CODE
#
# If your Emacs support files are installed in a subdirectory of
# /usr/share/emacs/site-lisp/ (which is strongly recommended), you need
# to extend Emacs' load-path as shown in the first non-comment line.
# The elisp-site-file-install() function of this eclass will replace
# "@SITELISP@" and "@SITEETC@" by the actual paths.
#
# The next line tells Emacs to load the mode opening a file ending
# with ".csv" and load functions depending on the context and needed
# features.  Be careful though.  Commands as "load-library" or "require"
# bloat the editor as they are loaded on every startup.  When having
# many Emacs support files, users may be annoyed by the start-up time.
# Also avoid keybindings as they might interfere with the user's
# settings.  Give a hint in pkg_postinst(), which should be enough.
# The guiding principle is that emerging your package should not by
# itself cause a change of standard Emacs behaviour.
#
# The naming scheme for this site-init file matches the shell pattern
# "[1-8][0-9]*-gentoo*.el", where the two digits at the beginning define
# the loading order (numbers below 10 or above 89 are reserved for
# internal use).  So if your initialisation depends on another Emacs
# package, your site file's number must be higher!  If there are no such
# interdependencies then the number should be 50.  Otherwise, numbers
# divisible by 10 are preferred.
#
# Best practice is to define a SITEFILE variable in the global scope of
# your ebuild (e.g., right after S or RDEPEND):
#
# @CODE
# 	SITEFILE="50${PN}-gentoo.el"
# @CODE
#
# Which is then installed by
#
# @CODE
# 	elisp-site-file-install "${FILESDIR}/${SITEFILE}"
# @CODE
#
# in src_install().  Any characters after the "-gentoo" part and before
# the extension will be stripped from the destination file's name.
# For example, a file "50${PN}-gentoo-${PV}.el" will be installed as
# "50${PN}-gentoo.el".  If your subdirectory is not named ${PN}, give
# the differing name as second argument.
#
# @ROFF .SS
# pkg_postinst() / pkg_postrm() usage:
#
# After that you need to recreate the start-up file of Emacs after
# emerging and unmerging by using
#
# @CODE
# 	pkg_postinst() {
# 		elisp-site-regen
# 	}
#
# 	pkg_postrm() {
# 		elisp-site-regen
# 	}
# @CODE
#
# When having optional Emacs support, you should prepend "use emacs &&"
# to above calls of elisp-site-regen().
# Don't use "has_version virtual/emacs"!  When unmerging the state of
# the emacs USE flag is taken from the package database and not from the
# environment, so it is no problem when you unset USE=emacs between
# merge and unmerge of a package.

# @ECLASS-VARIABLE: SITELISP
# @DESCRIPTION:
# Directory where packages install Emacs Lisp files.
SITELISP=/usr/share/emacs/site-lisp

# @ECLASS-VARIABLE: SITEETC
# @DESCRIPTION:
# Directory where packages install miscellaneous (not Lisp) files.
SITEETC=/usr/share/emacs/etc

# @ECLASS-VARIABLE: EMACS
# @DESCRIPTION:
# Path of Emacs executable.
EMACS=${EPREFIX}/usr/bin/emacs

# @ECLASS-VARIABLE: EMACSFLAGS
# @DESCRIPTION:
# Flags for executing Emacs in batch mode.
# These work for Emacs versions 18-24, so don't change them.
EMACSFLAGS="-batch -q --no-site-file"

# @ECLASS-VARIABLE: BYTECOMPFLAGS
# @DESCRIPTION:
# Emacs flags used for byte-compilation in elisp-compile().
BYTECOMPFLAGS="-L ."

# @FUNCTION: elisp-emacs-version
# @RETURN: exit status of Emacs
# @DESCRIPTION:
# Output version of currently active Emacs.

elisp-emacs-version() {
	local version ret
	# The following will work for at least versions 18-24.
	echo "(princ emacs-version)" >"${T}"/emacs-version.el
	version=$(
		# EMACS could be a microemacs variant that ignores the -batch
		# option and would therefore hang, waiting for user interaction.
		# Redirecting stdin and unsetting TERM and DISPLAY will cause
		# most of them to exit with an error.
		unset TERM DISPLAY
		${EMACS} ${EMACSFLAGS} -l "${T}"/emacs-version.el </dev/null
	)
	ret=$?
	rm -f "${T}"/emacs-version.el
	if [[ ${ret} -ne 0 ]]; then
		eerror "elisp-emacs-version: Failed to run ${EMACS}"
		return ${ret}
	fi
	if [[ -z ${version} ]]; then
		eerror "elisp-emacs-version: Could not determine Emacs version"
		return 1
	fi
	echo "${version}"
}

# @FUNCTION: elisp-need-emacs
# @USAGE: <version>
# @RETURN: 0 if true, 1 if false, 2 if trouble
# @DESCRIPTION:
# Test if the eselected Emacs version is at least the major version
# of GNU Emacs specified as argument.

elisp-need-emacs() {
	local need_emacs=$1 have_emacs
	have_emacs=$(elisp-emacs-version) || return 2
	einfo "Emacs version: ${have_emacs}"
	if [[ ${have_emacs} =~ XEmacs|Lucid ]]; then
		eerror "This package needs GNU Emacs."
		return 1
	fi
	if ! [[ ${have_emacs%%.*} -ge ${need_emacs%%.*} ]]; then
		eerror "This package needs at least Emacs ${need_emacs%%.*}."
		eerror "Use \"eselect emacs\" to select the active version."
		return 1
	fi
	return 0
}

# @FUNCTION: elisp-compile
# @USAGE: <list of elisp files>
# @DESCRIPTION:
# Byte-compile Emacs Lisp files.
#
# This function uses GNU Emacs to byte-compile all ".el" specified by
# its arguments.  The resulting byte-code (".elc") files are placed in
# the same directory as their corresponding source file.
#
# The current directory is added to the load-path.  This will ensure
# that interdependent Emacs Lisp files are visible between themselves,
# in case they require or load one another.

elisp-compile() {
	ebegin "Compiling GNU Emacs Elisp files"
	${EMACS} ${EMACSFLAGS} ${BYTECOMPFLAGS} -f batch-byte-compile "$@"
	eend $? "elisp-compile: batch-byte-compile failed" || die
}

# @FUNCTION: elisp-make-autoload-file
# @USAGE: [output file] [list of directories]
# @DESCRIPTION:
# Generate a file with autoload definitions for the lisp functions.

elisp-make-autoload-file() {
	local f="${1:-${PN}-autoloads.el}" null="" page=$'\f'
	shift
	ebegin "Generating autoload file for GNU Emacs"

	cat >"${f}" <<-EOF
	;;; ${f##*/} --- autoloads for ${PN}

	;;; Commentary:
	;; Automatically generated by elisp-common.eclass
	;; DO NOT EDIT THIS FILE

	;;; Code:
	${page}
	;; Local ${null}Variables:
	;; version-control: never
	;; no-byte-compile: t
	;; no-update-autoloads: t
	;; End:

	;;; ${f##*/} ends here
	EOF

	${EMACS} ${EMACSFLAGS} \
		--eval "(setq make-backup-files nil)" \
		--eval "(setq generated-autoload-file (expand-file-name \"${f}\"))" \
		-f batch-update-autoloads "${@-.}"

	eend $? "elisp-make-autoload-file: batch-update-autoloads failed" || die
}

# @FUNCTION: elisp-install
# @USAGE: <subdirectory> <list of files>
# @DESCRIPTION:
# Install files in SITELISP directory.

elisp-install() {
	local subdir="$1"
	shift
	ebegin "Installing Elisp files for GNU Emacs support"
	( # subshell to avoid pollution of calling environment
		insinto "${SITELISP}/${subdir}"
		doins "$@"
	)
	eend $? "elisp-install: doins failed" || die
}

# @FUNCTION: elisp-site-file-install
# @USAGE: <site-init file> [subdirectory]
# @DESCRIPTION:
# Install Emacs site-init file in SITELISP directory.  Automatically
# inserts a standard comment header with the name of the package (unless
# it is already present).  Tokens @SITELISP@ and @SITEETC@ are replaced
# by the path to the package's subdirectory in SITELISP and SITEETC,
# respectively.

elisp-site-file-install() {
	local sf="${1##*/}" my_pn="${2:-${PN}}" ret
	local header=";;; ${PN} site-lisp configuration"

	[[ ${sf} == [0-9][0-9]*-gentoo*.el ]] \
		|| ewarn "elisp-site-file-install: bad name of site-init file"
	[[ ${sf%-gentoo*.el} != "${sf}" ]] && sf="${sf%-gentoo*.el}-gentoo.el"
	sf="${T}/${sf}"
	ebegin "Installing site initialisation file for GNU Emacs"
	[[ $1 = "${sf}" ]] || cp "$1" "${sf}"
	sed -i -e "1{:x;/^\$/{n;bx;};/^;.*${PN}/I!s:^:${header}\n\n:;1s:^:\n:;}" \
		-e "s:@SITELISP@:${EPREFIX}${SITELISP}/${my_pn}:g" \
		-e "s:@SITEETC@:${EPREFIX}${SITEETC}/${my_pn}:g;\$q" "${sf}"
	( # subshell to avoid pollution of calling environment
		insinto "${SITELISP}/site-gentoo.d"
		doins "${sf}"
	)
	ret=$?
	rm -f "${sf}"
	eend ${ret} "elisp-site-file-install: doins failed" || die
}

# @FUNCTION: elisp-site-regen
# @DESCRIPTION:
# Regenerate the site-gentoo.el file, based on packages' site
# initialisation files in the /usr/share/emacs/site-lisp/site-gentoo.d/
# directory.

elisp-site-regen() {
	local sitelisp=${ROOT}${EPREFIX}${SITELISP}
	local sf i ret=0 null="" page=$'\f'
	local -a sflist

	if [[ ${EBUILD_PHASE} = *rm && ! -e ${sitelisp}/site-gentoo.el ]]; then
		ewarn "Refusing to create site-gentoo.el in ${EBUILD_PHASE} phase."
		return 0
	fi

	[[ -d ${sitelisp} ]] \
		|| die "elisp-site-regen: Directory ${sitelisp} does not exist"

	[[ -d ${T} ]] \
		|| die "elisp-site-regen: Temporary directory ${T} does not exist"

	ebegin "Regenerating site-gentoo.el for GNU Emacs (${EBUILD_PHASE})"

	for sf in "${sitelisp}"/site-gentoo.d/[0-9][0-9]*.el; do
		[[ -r ${sf} ]] && sflist+=("${sf}")
	done

	cat <<-EOF >"${T}"/site-gentoo.el || ret=$?
	;;; site-gentoo.el --- site initialisation for Gentoo-installed packages

	;;; Commentary:
	;; Automatically generated by elisp-common.eclass
	;; DO NOT EDIT THIS FILE

	;;; Code:
	EOF
	# Use sed instead of cat here, since files may miss a trailing newline.
	sed '$q' "${sflist[@]}" </dev/null >>"${T}"/site-gentoo.el || ret=$?
	cat <<-EOF >>"${T}"/site-gentoo.el || ret=$?

	${page}
	(provide 'site-gentoo)

	;; Local ${null}Variables:
	;; no-byte-compile: t
	;; buffer-read-only: t
	;; End:

	;;; site-gentoo.el ends here
	EOF

	if [[ ${ret} -ne 0 ]]; then
		eend ${ret} "elisp-site-regen: Writing site-gentoo.el failed."
		die
	elif cmp -s "${sitelisp}"/site-gentoo.el "${T}"/site-gentoo.el; then
		# This prevents outputting unnecessary text when there
		# was actually no change.
		# A case is a remerge where we have doubled output.
		rm -f "${T}"/site-gentoo.el
		eend
		einfo "... no changes."
	else
		mv "${T}"/site-gentoo.el "${sitelisp}"/site-gentoo.el
		eend $? "elisp-site-regen: Replacing site-gentoo.el failed" || die
		case ${#sflist[@]} in
			0) [[ ${PN} = emacs-common-gentoo ]] \
				|| ewarn "... Huh? No site initialisation files found." ;;
			1) einfo "... ${#sflist[@]} site initialisation file included." ;;
			*) einfo "... ${#sflist[@]} site initialisation files included." ;;
		esac
	fi

	return 0
}
