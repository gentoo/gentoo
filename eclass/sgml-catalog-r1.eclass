# Copyright 2019-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: sgml-catalog-r1.eclass
# @MAINTAINER:
# Michał Górny <mgorny@gentoo.org>
# @AUTHOR:
# Michał Górny <mgorny@gentoo.org>
# @SUPPORTED_EAPIS: 7 8 9
# @BLURB: Functions for installing SGML catalogs
# @DESCRIPTION:
# This eclass regenerates /etc/sgml/catalog as necessary for the DocBook
# tooling. This is done via exported pkg_postinst and pkg_postrm phases.

if [[ -z ${_SGML_CATALOG_R1_ECLASS} ]]; then
_SGML_CATALOG_R1_ECLASS=1

case ${EAPI} in
	7|8|9) ;;
	*) die "${ECLASS}: EAPI ${EAPI:-0} not supported" ;;
esac

if [[ ${CATEGORY}/${PN} != app-text/sgml-common ]]; then
	RDEPEND=">=app-text/sgml-common-0.6.3-r7"
fi

# @FUNCTION: sgml-catalog-r1_update_catalog
# @DESCRIPTION:
# Regenerate /etc/sgml/catalog to include all installed catalogs.
sgml-catalog-r1_update_catalog() {
	local shopt_save=$(shopt -p nullglob)
	shopt -s nullglob
	local cats=( "${EROOT}"/etc/sgml/*.cat )
	${shopt_save}

	if [[ ${#cats[@]} -gt 0 ]]; then
		ebegin "Updating ${EROOT}/etc/sgml/catalog"
		printf 'CATALOG "%s"\n' "${cats[@]#${ROOT}}" > "${T}"/catalog &&
		mv "${T}"/catalog "${EROOT}"/etc/sgml/catalog
		eend "${?}"
	else
		ebegin "Removing ${EROOT}/etc/sgml/catalog"
		rm "${EROOT}"/etc/sgml/catalog &&
		{ rmdir "${EROOT}"/etc/sgml &>/dev/null || :; }
		eend "${?}"
	fi
}

# @FUNCTION: sgml-catalog-r1_update_env
# @DESCRIPTION:
# Remove obsolete environment files. They can break tools such as asciidoc.
sgml-catalog-r1_update_env() {
	rm -f "${EROOT}"/etc/env.d/93sgmltools-lite "${EROOT}"/etc/sgml/sgml.{,c}env
}

sgml-catalog-r1_pkg_postinst() {
	sgml-catalog-r1_update_catalog
	sgml-catalog-r1_update_env
}

sgml-catalog-r1_pkg_postrm() {
	sgml-catalog-r1_update_catalog
	sgml-catalog-r1_update_env
}

fi

EXPORT_FUNCTIONS pkg_postinst pkg_postrm
