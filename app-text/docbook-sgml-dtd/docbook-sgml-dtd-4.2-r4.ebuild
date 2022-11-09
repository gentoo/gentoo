# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit sgml-catalog-r1

MY_P="docbook-${PV}"
DESCRIPTION="Docbook SGML DTD ${PV}"
HOMEPAGE="https://docbook.org/sgml/"
SRC_URI="https://www.oasis-open.org/docbook/sgml/${PV}/${MY_P}.zip"

LICENSE="docbook"
SLOT="${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris"
IUSE=""

BDEPEND=">=app-arch/unzip-5.41"

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
	local backup=${T}/sgml-docbook-${PV}.cat
	local real=${EROOT}/etc/sgml/sgml-docbook-${PV}.cat
	if ! cmp -s "${backup}" "${real}"; then
		cp "${backup}" "${real}" || die
	fi
	sgml-catalog-r1_pkg_postinst
}
