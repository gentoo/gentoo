# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit sgml-catalog-r1

MY_P=simple${PV//./}
DESCRIPTION="Simplified Docbook DTD for XML"
HOMEPAGE="https://www.oasis-open.org/docbook/xml/simple/4.1.2.5/"
SRC_URI="https://www.oasis-open.org/docbook/xml/simple/${PV}/${MY_P}.zip"

LICENSE="docbook"
SLOT="${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-linux ~x86-linux ~x86-macos ~sparc-solaris"
IUSE=""

RDEPEND=">=app-text/build-docbook-catalog-1.6"
DEPEND=">=app-arch/unzip-5.41"

S=${WORKDIR}

src_install() {
	insinto /usr/share/sgml/docbook/${P#docbook-}
	doins *.dtd *.mod *.css
	newins "${FILESDIR}"/${P}.catalog catalog

	insinto /etc/sgml
	newins - "xml-simple-docbook-${PV}.cat" <<-EOF
		CATALOG "${EPREFIX}/usr/share/sgml/docbook/xml-simple-dtd-${PV}/catalog"
	EOF
}

pkg_preinst() {
	# work-around old revision removing it
	cp "${ED}"/etc/sgml/xml-simple-docbook-${PV}.cat "${T}" || die
}

pkg_postinst() {
	local backup=${T}/xml-simple-docbook-${PV}.cat
	local real=${EROOT}/etc/sgml/xml-simple-docbook-${PV}.cat
	if ! cmp -s "${backup}" "${real}"; then
		cp "${backup}" "${real}" || die
	fi
	build-docbook-catalog
	sgml-catalog-r1_pkg_postinst
}

pkg_postrm() {
	build-docbook-catalog
	sgml-catalog-r1_pkg_postrm
}
