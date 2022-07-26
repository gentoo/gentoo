# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit sgml-catalog-r1

DESCRIPTION="DTDs for the eXtensible HyperText Markup Language 1.0"
HOMEPAGE="https://www.w3.org/TR/xhtml1/"
SRC_URI="mirror://gentoo/${P}.tgz"

LICENSE="W3C"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND="app-text/sgml-common
	dev-libs/libxml2"

PATCHES=( "${FILESDIR}"/${PN}-catalog.patch )

xml_catalog_setup() {
	CATALOG="${EROOT}/etc/xml/catalog"
	XMLTOOL="${BROOT}/usr/bin/xmlcatalog"
	DTDDIR="${EROOT}/usr/share/sgml/${PN}"

	[[ -x ${XMLTOOL} ]]
}

src_install() {
	insinto /usr/share/sgml/${PN}
	doins DTD/xhtml.soc DTD/*.dcl DTD/*.dtd DTD/*.ent

	insinto /etc/sgml
	newins - xhtml1.cat <<-EOF
		CATALOG "${EPREFIX}/usr/share/sgml/xhtml1/xhtml.soc"
	EOF

	dodoc *.pdf *.ps
	docinto html
	dodoc *.html *.png *.css
}

pkg_preinst() {
	# work-around old revision removing it
	cp "${ED}"/etc/sgml/xhtml1.cat "${T}" || die
}

pkg_postinst() {
	local backup=${T}/xhtml1.cat
	local real=${EROOT}/etc/sgml/xhtml1.cat
	if ! cmp -s "${backup}" "${real}"; then
		cp "${backup}" "${real}" || die
	fi
	sgml-catalog-r1_pkg_postinst

	xml_catalog_setup || return
	einfo "Installing xhtml1 in the global XML catalog"
	"${XMLTOOL}" --noout --add 'public' '-//W3C//DTD XHTML 1.0 Strict//EN' \
		"${DTDDIR}"/xhtml1-strict.dtd "${CATALOG}"
	"${XMLTOOL}" --noout --add 'public' '-//W3C//DTD XHTML 1.0 Transitional//EN' \
		"${DTDDIR}"/xhtml1-transitional.dtd "${CATALOG}"
	"${XMLTOOL}" --noout --add 'public' '-//W3C//DTD XHTML 1.0 Frameset//EN' \
		"${DTDDIR}"/xhtml1-frameset.dtd "${CATALOG}"
	"${XMLTOOL}" --noout --add 'rewriteSystem' 'http://www.w3.org/TR/xhtml1/DTD' \
		"${DTDDIR}" "${CATALOG}"
	"${XMLTOOL}" --noout --add 'rewriteURI' 'http://www.w3.org/TR/xhtml1/DTD' \
		"${DTDDIR}" "${CATALOG}"
}

pkg_postrm() {
	sgml-catalog-r1_pkg_postrm

	[[ -n ${REPLACED_BY_VERSION} ]] && return
	xml_catalog_setup || return
	einfo "Removing xhtml1 from the global XML catalog"
	"${XMLTOOL}" --noout --del '-//W3C//DTD XHTML 1.0 Strict//EN' "${CATALOG}"
	"${XMLTOOL}" --noout --del '-//W3C//DTD XHTML 1.0 Transitional//EN' "${CATALOG}"
	"${XMLTOOL}" --noout --del '-//W3C//DTD XHTML 1.0 Frameset//EN' "${CATALOG}"
	"${XMLTOOL}" --noout --del 'http://www.w3.org/TR/xhtml1/DTD' "${CATALOG}"
}
