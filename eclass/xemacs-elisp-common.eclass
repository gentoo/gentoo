# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
#
# Copyright 2007-2011 Hans de Graaff <graaff@gentoo.org>
#
# Based on elisp-common.eclass:
# Copyright 2007 Christian Faulhammer <opfer@gentoo.org>
# Copyright 2002-2004 Matthew Kennedy <mkennedy@gentoo.org>
# Copyright 2004-2005 Mamoru Komachi <usata@gentoo.org>
# Copyright 2003 Jeremy Maitin-Shepard <jbms@attbi.com>
# Copyright 2007 Ulrich Müller <ulm@gentoo.org>
#
# @ECLASS: xemacs-elisp-common.eclass
# @MAINTAINER:
# xemacs@gentoo.org
# @BLURB: XEmacs-related installation utilities
# @DESCRIPTION:
#
# Usually you want to use this eclass for (optional) XEmacs support of
# your package.  This is NOT for GNU Emacs!
#
# Many of the steps here are sometimes done by the build system of your
# package (especially compilation), so this is mainly for standalone elisp
# files you gathered from somewhere else.
#
# When relying on the xemacs USE flag, you need to add
#
#       xemacs? ( app-editors/xemacs )
#
# to your DEPEND/RDEPEND line and use the functions provided here to bring
# the files to the correct locations.
#
# @ROFF .SS
# src_compile() usage:
#
# An elisp file is compiled by the xemacs-elisp-compile() function
# defined here and simply takes the source files as arguments.
#
#   xemacs-elisp-compile *.el
#
# In the case of interdependent elisp files, you can use the
# xemacs-elisp-comp() function which makes sure all files are
# loadable.
#
#   xemacs-elisp-comp *.el
#
# Function xemacs-elisp-make-autoload-file() can be used to generate a
# file with autoload definitions for the lisp functions.  It takes a
# list of directories (default: working directory) as its argument.
# Use of this function requires that the elisp source files contain
# magic ";;;###autoload" comments. See the XEmacs Lisp Reference Manual
# (node "Autoload") for a detailed explanation.
#
# @ROFF .SS
# src_install() usage:
#
# The resulting compiled files (.elc) should be put in a subdirectory
# of /usr/lib/xemacs/site-lisp/ which is named after the first
# argument of xemacs-elisp-install().  The following parameters are
# the files to be put in that directory.  Usually the subdirectory
# should be ${PN}, but you can choose something else.
#
#   xemacs-elisp-install ${PN} *.el *.elc
#
# To let the XEmacs support be activated by XEmacs on startup, you need
# to provide a site file (shipped in ${FILESDIR}) which contains the
# startup code (have a look in the documentation of your software).
# Normally this would look like this:
#
#   	(add-to-list 'load-path "@SITELISP@")
#   	(add-to-list 'auto-mode-alist '("\\.csv\\'" . csv-mode))
#   	(autoload 'csv-mode "csv-mode" "Major mode for csv files." t)
#
# If your XEmacs support files are installed in a subdirectory of
# /usr/share/xemacs/site-packages/ (which is strongly recommended), you need
# to extend XEmacs' load-path as shown in the first non-comment line.
# The xemacs-elisp-site-file-install() function of this eclass will replace
# "@SITELISP@" by the actual path.
#
# The next line tells XEmacs to load the mode opening a file ending
# with ".csv" and load functions depending on the context and needed
# features.  Be careful though.  Commands as "load-library" or "require"
# bloat the editor as they are loaded on every startup.  When having
# many XEmacs support files, users may be annoyed by the start-up time.
# Also avoid keybindings as they might interfere with the user's
# settings.  Give a hint in pkg_postinst(), which should be enough.
#
# The naming scheme for this site-init file matches the shell pattern
# "[1-8][0-9]*-gentoo*.el", where the two digits at the beginning define
# the loading order (numbers below 10 or above 89 are reserved for
# internal use).  So if your initialisation depends on another XEmacs
# package, your site file's number must be higher!  If there are no such
# interdependencies then the number should be 50.  Otherwise, numbers
# divisible by 10 are preferred.
#
# Best practice is to define a SITEFILE variable in the global scope of
# your ebuild (e.g., right after S or RDEPEND):
#
#   	SITEFILE="50${PN}-gentoo.el"
#
# Which is then installed by
#
#   	xemacs-elisp-site-file-install "${FILESDIR}/${SITEFILE}" || die
#
# in src_install().  Any characters after the "-gentoo" part and before
# the extension will be stripped from the destination file's name.
# For example, a file "50${PN}-gentoo-${PV}.el" will be installed as
# "50${PN}-gentoo.el".  If your subdirectory is not named ${PN}, give
# the differing name as second argument.

# @ECLASS-VARIABLE: XEMACS_SITELISP
# @DESCRIPTION:
# Directory where packages install indivivual XEmacs Lisp files.
XEMACS_SITELISP=/usr/share/xemacs/site-lisp

# @ECLASS-VARIABLE: XEMACS_SITEPACKAGE
# @DESCRIPTION:
# Directory where packages install XEmacs Lisp packages.
XEMACS_SITEPACKAGE=/usr/share/xemacs/site-packages

# @ECLASS-VARIABLE: XEMACS
# @DESCRIPTION:
# Path of XEmacs executable.
XEMACS=/usr/bin/xemacs

# @ECLASS-VARIABLE: XEMACS_BATCH_CLEAN
# @DESCRIPTION:
# Invocation of XEMACS in batch mode.
XEMACS_BATCH_CLEAN="${XEMACS} --batch --no-site-file --no-init-file"

# @FUNCTION: xemacs-elisp-compile
# @USAGE: <list of elisp files>
# @DESCRIPTION:
# Byte-compile elisp files with xemacs. This function will die when
# there is a problem compiling the lisp files.
xemacs-elisp-compile () {
	{
		${XEMACS_BATCH_CLEAN} -f batch-byte-compile "$@"
		xemacs-elisp-make-autoload-file "$@"
	} || die "Compile lisp files failed"
}

xemacs-elisp-make-autoload-file () {
	${XEMACS_BATCH_CLEAN} \
		-eval "(setq autoload-package-name \"${PN}\")" \
		-eval "(setq generated-autoload-file \"${S}/auto-autoloads.el\")" \
		-l autoload -f batch-update-autoloads "$@"
}

# @FUNCTION: xemacs-elisp-install
# @USAGE: <subdirectory> <list of files>
# @DESCRIPTION:
# Install elisp source and byte-compiled files. All files are installed
# in site-packages in their own directory, indicated by the first
# argument to the function. This function will die if there is a problem
# installing the list files.

xemacs-elisp-install () {
	local subdir="$1"
	shift
	(  # use sub-shell to avoid possible environment polution
		dodir "${XEMACS_SITEPACKAGE}"/lisp/"${subdir}"
		insinto "${XEMACS_SITEPACKAGE}"/lisp/"${subdir}"
		doins "$@"
	) || die "Installing lisp files failed"
}

# @FUNCTION: xemacs-elisp-comp
# @USAGE: <list of elisp files>
# @DESCRIPTION:
# Byte-compile interdependent XEmacs lisp files.
# Originally taken from GNU autotools, but some configuration options
# removed as they don't make sense with the current status of XEmacs
# in Gentoo.

xemacs-elisp-comp() {
	# Copyright 1995 Free Software Foundation, Inc.
	# François Pinard <pinard@iro.umontreal.ca>, 1995.
	# This script byte-compiles all `.el' files which are part of its
	# arguments, using XEmacs, and put the resulting `.elc' files into
	# the current directory, so disregarding the original directories used
	# in `.el' arguments.
	#
	# This script manages in such a way that all XEmacs LISP files to
	# be compiled are made visible between themselves, in the event
	# they require or load-library one another.

	test $# -gt 0 || return 1

	einfo "Compiling XEmacs Elisp files ..."

	tempdir=elc.$$
	mkdir ${tempdir}
	cp "$@" ${tempdir}
	pushd ${tempdir}

	echo "(add-to-list 'load-path \"../\")" > script
	${XEMACS_BATCH_CLEAN} -l script -f batch-byte-compile *.el
	local ret=$?
	mv *.elc ..

	popd
	rm -fr ${tempdir}
	return ${ret}
}

# @FUNCTION: xemacs-elisp-site-file-install
# @USAGE: <site-init file> [subdirectory]
# @DESCRIPTION:
# Install XEmacs site-init file in XEMACS_SITELISP directory.
# Automatically inserts a standard comment header with the name of the
# package (unless it is already present).  Token @SITELISP@ is replaced
# by the path to the package's subdirectory in XEMACS_SITELISP.

xemacs-elisp-site-file-install() {
	local sf="${1##*/}" my_pn="${2:-${PN}}" ret
	local header=";;; ${PN} site-lisp configuration"

	[[ ${sf} == [0-9][0-9]*-gentoo*.el ]] \
		|| ewarn "xemacs-elisp-site-file-install: bad name of site-init file"
	sf="${T}/${sf/%-gentoo*.el/-gentoo.el}"
	ebegin "Installing site initialisation file for XEmacs"
	[[ $1 = "${sf}" ]] || cp "$1" "${sf}"
	sed -i -e "1{:x;/^\$/{n;bx;};/^;.*${PN}/I!s:^:${header}\n\n:;1s:^:\n:;}" \
		-e "s:@SITELISP@:${EPREFIX}${XEMACS_SITELISP}/${my_pn}:g" "${sf}"
	( # subshell to avoid pollution of calling environment
		insinto "${XEMACS_SITELISP}/site-gentoo.d"
		doins "${sf}"
	)
	ret=$?
	rm -f "${sf}"
	eend ${ret} "xemacs-elisp-site-file-install: doins failed"
}

# @FUNCTION: xemacs-elisp-site-regen
# @DESCRIPTION:
# Regenerate the site-gentoo.el file, based on packages' site
# initialisation files in the /usr/share/xemacs/site-lisp/site-gentoo.d/
# directory.

xemacs-elisp-site-regen() {
	local sitelisp=${ROOT}${EPREFIX}${XEMACS_SITELISP}
	local sf i line null="" page=$'\f'
	local -a sflist

	if [ ! -d "${sitelisp}" ]; then
		eerror "xemacs-elisp-site-regen: Directory ${sitelisp} does not exist"
		return 1
	fi

	if [ ! -d "${T}" ]; then
		eerror "xemacs-elisp-site-regen: Temporary directory ${T} does not exist"
		return 1
	fi

	einfon "Regenerating site-gentoo.el for XEmacs (${EBUILD_PHASE}) ..."

	for sf in "${sitelisp}"/site-gentoo.d/[0-9][0-9]*.el
	do
		[ -r "${sf}" ] || continue
		# sort files by their basename. straight insertion sort.
		for ((i=${#sflist[@]}; i>0; i--)); do
			[[ ${sf##*/} < ${sflist[i-1]##*/} ]] || break
			sflist[i]=${sflist[i-1]}
		done
		sflist[i]=${sf}
	done

	cat <<-EOF >"${T}"/site-gentoo.el
	;;; site-gentoo.el --- site initialisation for Gentoo-installed packages

	;;; Commentary:
	;; Automatically generated by xemacs-elisp-common.eclass
	;; DO NOT EDIT THIS FILE

	;;; Code:
	EOF
	# Use sed instead of cat here, since files may miss a trailing newline.
	sed '$q' "${sflist[@]}" </dev/null >>"${T}"/site-gentoo.el
	cat <<-EOF >>"${T}"/site-gentoo.el

	${page}
	(provide 'site-gentoo)

	;; Local ${null}Variables:
	;; no-byte-compile: t
	;; buffer-read-only: t
	;; End:

	;;; site-gentoo.el ends here
	EOF

	if cmp -s "${sitelisp}"/site-gentoo.el "${T}"/site-gentoo.el; then
		# This prevents outputting unnecessary text when there
		# was actually no change.
		# A case is a remerge where we have doubled output.
		rm -f "${T}"/site-gentoo.el
		echo " no changes."
	else
		mv "${T}"/site-gentoo.el "${sitelisp}"/site-gentoo.el
		echo
		case ${#sflist[@]} in
			0) ewarn "... Huh? No site initialisation files found." ;;
			1) einfo "... ${#sflist[@]} site initialisation file included." ;;
			*) einfo "... ${#sflist[@]} site initialisation files included." ;;
		esac
	fi

	return 0
}
