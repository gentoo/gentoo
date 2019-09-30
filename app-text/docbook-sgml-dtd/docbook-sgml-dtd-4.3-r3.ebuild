# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit sgml-catalog-r1

MY_P="docbook-${PV}"
DESCRIPTION="Docbook SGML DTD ${PV}"
HOMEPAGE="https://docbook.org/sgml/"
SRC_URI="https://docbook.org/sgml/${PV}/${MY_P}.zip"

LICENSE="docbook"
SLOT="${PV}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris ~x64-solaris"
IUSE=""

DEPEND=">=app-arch/unzip-5.41"

S="${WORKDIR}"
PATCHES=( "${FILESDIR}"/${P}-catalog.diff )

src_install() {
	insinto /usr/share/sgml/docbook/sgml-dtd-${PV}
	doins *.dcl *.dtd *.mod
	newins docbook.cat catalog
	insinto /etc/sgml
	newins - sgml-docbook-${PV}.cat <<-EOF
		CATALOG "${EPREFIX}/usr/share/sgml/docbook/sgml-dtd-${PV}/catalog"
		CATALOG "${EPREFIX}/etc/sgml/sgml-docbook.cat"
	EOF
	dodoc ChangeLog README
}

pkg_preinst() {
	# work-around -r2 postrm removing it
	cp "${ED}"/etc/sgml/sgml-docbook-${PV}.cat "${T}" || die
}

pkg_postinst() {
	if [[ ! -f ${EROOT}/etc/sgml/sgml-docbook-${PV}.cat ]]; then
		cp "${T}"/sgml-docbook-${PV}.cat "${EROOT}"/etc/sgml/ || die
	fi
	sgml-catalog-r1_pkg_postinst
}
