# Copyright 2002-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: elisp.eclass
# @MAINTAINER:
# Gentoo GNU Emacs project <gnu-emacs@gentoo.org>
# @AUTHOR:
# Matthew Kennedy <mkennedy@gentoo.org>
# Jeremy Maitin-Shepard <jbms@attbi.com>
# Christian Faulhammer <fauli@gentoo.org>
# Ulrich Müller <ulm@gentoo.org>
# @SUPPORTED_EAPIS: 6 7 8
# @PROVIDES: elisp-common
# @BLURB: Eclass for Emacs Lisp packages
# @DESCRIPTION:
#
# This eclass is designed to install elisp files of Emacs related
# packages into the site-lisp directory.  The majority of elisp packages
# will only need to define the standard ebuild variables (like ``SRC_URI``)
# and optionally ``SITEFILE`` for successful installation.
#
# Emacs support for other than pure elisp packages is handled by
# elisp-common.eclass where you won't have a dependency on Emacs itself.
# All ``elisp-*`` functions are documented there.
#
# If the package's source is a single (in whatever way) compressed elisp
# file with the file name ``${P}.el``, then this eclass will move ``${P}.el``
# to ``${PN}.el`` in ``src_unpack()``.

# @ECLASS_VARIABLE: NEED_EMACS
# @PRE_INHERIT
# @DEFAULT_UNSET
# @DESCRIPTION:
# If you need anything different from Emacs 23, use the ``NEED_EMACS``
# variable before inheriting elisp.eclass.  Set it to the version your
# package uses and the dependency will be adjusted.

# @ECLASS_VARIABLE: ELISP_PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Space separated list of patches to apply after unpacking the sources.
# Patch files are searched for in the current working dir, ``WORKDIR``, and
# ``FILESDIR``.  This variable is semi-deprecated, preferably use the
# PATCHES array instead.

# @ECLASS_VARIABLE: ELISP_REMOVE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Space separated list of files to remove after unpacking the sources.

# @ECLASS_VARIABLE: SITEFILE
# @DEFAULT_UNSET
# @DESCRIPTION:
# Name of package's site-init file.  The filename must match the shell
# pattern ``[1-8][0-9]*-gentoo.el``; numbers below 10 and above 89 are
# reserved for internal use.  ``50${PN}-gentoo.el`` is a reasonable choice
# in most cases.

# @ECLASS_VARIABLE: ELISP_TEXINFO
# @DEFAULT_UNSET
# @DESCRIPTION:
# Space separated list of Texinfo sources.  Respective GNU Info files
# will be generated in ``src_compile()`` and installed in ``src_install()``.

inherit elisp-common

case ${EAPI} in
	6|7|8) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

EXPORT_FUNCTIONS src_{unpack,prepare,configure,compile,install} \
	pkg_{setup,postinst,postrm}

RDEPEND=">=app-editors/emacs-${NEED_EMACS}:*"
case ${EAPI} in
	6) DEPEND="${RDEPEND}" ;;
	*) BDEPEND="${RDEPEND}" ;;
esac

# @FUNCTION: elisp_pkg_setup
# @DESCRIPTION:
# Test if the eselected Emacs version is sufficient to fulfil the
# version requirement of the ``NEED_EMACS`` variable.

elisp_pkg_setup() {
	elisp-check-emacs-version
}

# @FUNCTION: elisp_src_unpack
# @DESCRIPTION:
# Unpack the sources; also handle the case of a single ``*.el`` file in
# ``WORKDIR`` for packages distributed that way.

elisp_src_unpack() {
	default
	if [[ -f ${P}.el ]]; then
		# the "simple elisp" case with a single *.el file in WORKDIR
		mv ${P}.el ${PN}.el || die
		[[ -d ${S} ]] || S=${WORKDIR}
	fi
}

# @FUNCTION: elisp_src_prepare
# @DESCRIPTION:
# Apply any patches listed in ``ELISP_PATCHES``.  Patch files are searched
# for in the current working dir, ``WORKDIR``, and ``FILESDIR``.

elisp_src_prepare() {
	local patch file
	for patch in ${ELISP_PATCHES}; do
		if [[ -f ${patch} ]]; then
			file="${patch}"
		elif [[ -f ${WORKDIR}/${patch} ]]; then
			file="${WORKDIR}/${patch}"
		elif [[ -f ${FILESDIR}/${patch} ]]; then
			file="${FILESDIR}/${patch}"
		else
			die "Cannot find ${patch}"
		fi
		eapply "${file}"
	done

	# apply PATCHES and any user patches
	default

	if [[ -n ${ELISP_REMOVE} ]]; then
		rm ${ELISP_REMOVE} || die
	fi
}

# @FUNCTION: elisp_src_configure
# @DESCRIPTION:
# Do nothing, because Emacs packages seldomly bring a full build system.

elisp_src_configure() { :; }

# @FUNCTION: elisp_src_compile
# @DESCRIPTION:
# Call ``elisp-compile`` to byte-compile all Emacs Lisp (``*.el``) files.
# If ``ELISP_TEXINFO`` lists any Texinfo sources, call ``makeinfo`` to generate
# GNU Info files from them.

elisp_src_compile() {
	elisp-compile *.el
	if [[ -n ${ELISP_TEXINFO} ]]; then
		makeinfo ${ELISP_TEXINFO} || die
	fi
}

# @FUNCTION: elisp_src_install
# @DESCRIPTION:
# Call ``elisp-install`` to install all Emacs Lisp (``*.el`` and ``*.elc``)
# files. If the ``SITEFILE`` variable specifies a site-init file, install it
# with ``elisp-site-file-install``.  Also install any GNU Info files listed in
# ``ELISP_TEXINFO`` and documentation listed in the ``DOCS`` variable.

elisp_src_install() {
	elisp-install ${PN} *.el *.elc
	if [[ -n ${SITEFILE} ]]; then
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
	if [[ -n ${ELISP_TEXINFO} ]]; then
		set -- ${ELISP_TEXINFO}
		set -- ${@##*/}
		doinfo ${@/%.*/.info*}
	fi
	# install documentation only when explicitly requested
	[[ $(declare -p DOCS 2>/dev/null) == *=* ]] && einstalldocs
	if declare -f readme.gentoo_create_doc >/dev/null; then
		readme.gentoo_create_doc
	fi
}

# @FUNCTION: elisp_pkg_postinst
# @DESCRIPTION:
# Call ``elisp-site-regen``, in order to collect the site initialisation for
# all installed Emacs Lisp packages in the ``site-gentoo.el`` file.

elisp_pkg_postinst() {
	elisp-site-regen
	if declare -f readme.gentoo_print_elog >/dev/null; then
		readme.gentoo_print_elog
	fi
}

# @FUNCTION: elisp_pkg_postrm
# @DESCRIPTION:
# Call ``elisp-site-regen``, in order to collect the site initialisation for
# all installed Emacs Lisp packages in the ``site-gentoo.el`` file.

elisp_pkg_postrm() {
	elisp-site-regen
}
