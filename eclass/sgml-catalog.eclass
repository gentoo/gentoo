# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# @DEAD
# All consumers are gone.  Removal in 14 days

# @ECLASS: sgml-catalog.eclass
# @MAINTAINER:
# No maintainer <maintainer-needed@gentoo.org>
# @AUTHOR:
# Author Matthew Turk <satai@gentoo.org>
# @BLURB: Functions for installing SGML catalogs

case ${EAPI:-0} in
	0|1|2|3|4|5) inherit base ;;
	*) ;;
esac

DEPEND=">=app-text/sgml-common-0.6.3-r2"

# @ECLASS-VARIABLE: SGML_TOINSTALL
# @DESCRIPTION:
# An array of catalogs, arranged in pairs.
# Each pair consists of a centralized catalog followed by an ordinary catalog.
SGML_TOINSTALL=()

# @FUNCTION: sgml-catalog_cat_include
# @USAGE: <centralized catalog> <ordinary catalog>
# @DESCRIPTION:
# Appends a catalog pair to the SGML_TOINSTALL array.
sgml-catalog_cat_include() {
	debug-print function $FUNCNAME $*
	SGML_TOINSTALL+=("$1" "$2")
}

# @FUNCTION: sgml-catalog_cat_doinstall
# @USAGE: <centralized catalog> <ordinary catalog>
# @DESCRIPTION:
# Adds an ordinary catalog to a centralized catalog.
sgml-catalog_cat_doinstall() {
	debug-print function $FUNCNAME $*
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	"${EPREFIX}"/usr/bin/install-catalog --add "${EPREFIX}$1" "${EPREFIX}$2" &>/dev/null
}

# @FUNCTION: sgml-catalog_cat_doremove
# @USAGE: <centralized catalog> <ordinary catalog>
# @DESCRIPTION:
# Removes an ordinary catalog from a centralized catalog.
sgml-catalog_cat_doremove() {
	debug-print function $FUNCNAME $*
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	"${EPREFIX}"/usr/bin/install-catalog --remove "${EPREFIX}$1" "${EPREFIX}$2" &>/dev/null
}

sgml-catalog_pkg_postinst() {
	debug-print function $FUNCNAME $*
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=

	set -- "${SGML_TOINSTALL[@]}"

	while (( $# )); do
		if [[ ! -e "${EPREFIX}$2" ]]; then
			ewarn "${EPREFIX}$2 doesn't appear to exist, although it ought to!"
			shift 2
			continue
		fi
		einfo "Now adding ${EPREFIX}$2 to ${EPREFIX}$1 and ${EPREFIX}/etc/sgml/catalog"
		sgml-catalog_cat_doinstall "$1" "$2"
		shift 2
	done
	sgml-catalog_cleanup
}

sgml-catalog_pkg_prerm() {
	sgml-catalog_cleanup
}

sgml-catalog_pkg_postrm() {
	debug-print function $FUNCNAME $*
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=

	set -- "${SGML_TOINSTALL[@]}"

	while (( $# )); do
		einfo "Now removing ${EPREFIX}$2 from ${EPREFIX}$1 and ${EPREFIX}/etc/sgml/catalog"
		sgml-catalog_cat_doremove "$1" "$2"
		shift 2
	done
}

sgml-catalog_cleanup() {
	has "${EAPI:-0}" 0 1 2 && ! use prefix && EPREFIX=
	if [ -e "${EPREFIX}/usr/bin/gensgmlenv" ]
	then
		einfo Regenerating SGML environment variables ...
		gensgmlenv
		grep -v export "${EPREFIX}/etc/sgml/sgml.env" > "${EPREFIX}/etc/env.d/93sgmltools-lite"
	fi
}

sgml-catalog_src_compile() {
	return
}

EXPORT_FUNCTIONS pkg_postrm pkg_postinst src_compile pkg_prerm
