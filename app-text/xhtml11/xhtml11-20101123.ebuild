# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit sgml-catalog-r1

DESCRIPTION="DTDs for the eXtensible HyperText Markup Language 1.0"
HOMEPAGE="http://www.w3.org/TR/xhtml11/"
SRC_URI="http://www.w3.org/TR/xhtml11/xhtml11.tgz -> ${P}.tar.gz"

LICENSE="W3C"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="app-text/sgml-common
	dev-libs/libxml2"

xml_catalog_setup() {
	CATALOG="${EROOT}/etc/xml/catalog"
	XMLTOOL="${BROOT}/usr/bin/xmlcatalog"
	DTDDIR="${EROOT}/usr/share/sgml/${PN}"

	[[ -x ${XMLTOOL} ]]
}

src_install() {
	insinto /usr/share/sgml/${PN}
	doins DTD/*.{cat,dcl,dtd,mod}

	insinto /etc/sgml
	newins - xhtml11.cat <<-EOF
		CATALOG "${EPREFIX}/usr/share/sgml/xhtml11/xhtml11.cat"
	EOF

	dodoc *.pdf *.ps
	docinto html
	dodoc *.html *.gif *.css
}

pkg_postinst() {
	sgml-catalog-r1_pkg_postinst

	xml_catalog_setup || return
	einfo "Installing xhtml11 in the global XML catalog"
	"${XMLTOOL}" --noout --add 'public' '-//W3C//DTD XHTML 1.1//EN' \
		"${DTDDIR}"/xhtml11-flat.dtd "${CATALOG}"
	"${XMLTOOL}" --noout --add 'rewriteSystem' 'http://www.w3.org/TR/xhtml11/DTD' \
		"${DTDDIR}" "${CATALOG}"
	"${XMLTOOL}" --noout --add 'rewriteURI' 'http://www.w3.org/TR/xhtml11/DTD' \
		"${DTDDIR}" "${CATALOG}"
}

pkg_postrm() {
	sgml-catalog-r1_pkg_postrm

	[[ -n ${REPLACED_BY_VERSION} ]] && return
	xml_catalog_setup || return
	einfo "Removing xhtml1 from the global XML catalog"
	"${XMLTOOL}" --noout --del '-//W3C//DTD XHTML 1.1//EN' "${CATALOG}"
	"${XMLTOOL}" --noout --del 'http://www.w3.org/TR/xhtml11/DTD' "${CATALOG}"
}
