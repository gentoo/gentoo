# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: qt4-r2.eclass
# @MAINTAINER:
# qt@gentoo.org
# @BLURB: Eclass for Qt4-based packages, second edition.
# @DESCRIPTION:
# This eclass contains various functions that may be useful when
# dealing with packages using Qt4 libraries. Supports only EAPIs
# 2, 3, 4, and 5. Use qmake-utils.eclass in EAPI 6 and later.

case ${EAPI} in
	2|3|4|5) : ;;
	6) die "qt4-r2.eclass is banned in EAPI 6 and later" ;;
	*) die "qt4-r2.eclass: unsupported EAPI=${EAPI:-0}" ;;
esac

inherit base eutils qmake-utils

export XDG_CONFIG_HOME="${T}"

# @ECLASS-VARIABLE: DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array containing documents passed to dodoc command.
# Paths can be absolute or relative to ${S}.
#
# Example: DOCS=( ChangeLog README "${WORKDIR}/doc_folder/" )

# @ECLASS-VARIABLE: HTML_DOCS
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array containing documents passed to dohtml command.
# Paths can be absolute or relative to ${S}.
#
# Example: HTML_DOCS=( "doc/document.html" "${WORKDIR}/html_folder/" )

# @ECLASS-VARIABLE: LANGS
# @DEFAULT_UNSET
# @DESCRIPTION:
# In case your Qt4 application provides various translations, use this variable
# to specify them in order to populate "linguas_*" IUSE automatically. Make sure
# that you set this variable before inheriting qt4-r2 eclass.
#
# Example: LANGS="de el it ja"
for x in ${LANGS}; do
	IUSE+=" linguas_${x}"
done

# @ECLASS-VARIABLE: LANGSLONG
# @DEFAULT_UNSET
# @DESCRIPTION:
# Same as LANGS, but this variable is for LINGUAS that must be in long format.
# Remember to set this variable before inheriting qt4-r2 eclass.
# Look at ${PORTDIR}/profiles/desc/linguas.desc for details.
#
# Example: LANGSLONG="en_GB ru_RU"
for x in ${LANGSLONG}; do
	IUSE+=" linguas_${x%_*}"
done
unset x

# @ECLASS-VARIABLE: PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# Array variable containing all the patches to be applied. This variable
# is expected to be defined in the global scope of ebuilds. Make sure to
# specify the full path. This variable is used in src_prepare phase.
#
# Example:
# @CODE
# PATCHES=(
# 	"${FILESDIR}/mypatch.patch"
# 	"${FILESDIR}/mypatch2.patch"
# )
# @CODE

# @FUNCTION: qt4-r2_src_unpack
# @DESCRIPTION:
# Default src_unpack function for packages that depend on qt4. If you have to
# override src_unpack in your ebuild (probably you don't need to), call
# qt4-r2_src_unpack in it.
qt4-r2_src_unpack() {
	debug-print-function $FUNCNAME "$@"

	base_src_unpack "$@"
}

# @FUNCTION: qt4-r2_src_prepare
# @DESCRIPTION:
# Default src_prepare function for packages that depend on qt4. If you have to
# override src_prepare in your ebuild, you should call qt4-r2_src_prepare in it,
# otherwise autopatcher will not work!
qt4-r2_src_prepare() {
	debug-print-function $FUNCNAME "$@"

	base_src_prepare "$@"
}

# @FUNCTION: qt4-r2_src_configure
# @DESCRIPTION:
# Default src_configure function for packages that depend on qt4. If you have to
# override src_configure in your ebuild, call qt4-r2_src_configure in it.
qt4-r2_src_configure() {
	debug-print-function $FUNCNAME "$@"

	local project_file=$(qmake-utils_find_pro_file)

	if [[ -n ${project_file} ]]; then
		eqmake4 "${project_file}"
	else
		base_src_configure "$@"
	fi
}

# @FUNCTION: qt4-r2_src_compile
# @DESCRIPTION:
# Default src_compile function for packages that depend on qt4. If you have to
# override src_compile in your ebuild (probably you don't need to), call
# qt4-r2_src_compile in it.
qt4-r2_src_compile() {
	debug-print-function $FUNCNAME "$@"

	base_src_compile "$@"
}

# @FUNCTION: qt4-r2_src_install
# @DESCRIPTION:
# Default src_install function for qt4-based packages. Installs compiled code,
# and documentation (via DOCS and HTML_DOCS variables).
qt4-r2_src_install() {
	debug-print-function $FUNCNAME "$@"

	base_src_install INSTALL_ROOT="${D}" "$@"
	einstalldocs
}

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install
