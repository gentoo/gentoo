# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit sgml-catalog-r1

MY_P="sdb${PV//.}"
DESCRIPTION="Simplified Docbook DTD for XML"
HOMEPAGE="https://www.oasis-open.org/docbook/"
SRC_URI="mirror://gentoo/${MY_P}.zip"

LICENSE="docbook"
SLOT="${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris"
IUSE=""

RDEPEND=">=app-text/build-docbook-catalog-1.6"
DEPEND=">=app-arch/unzip-5.41"

S=${WORKDIR}

src_install() {
	insinto /usr/share/sgml/docbook/${P#docbook-}
	doins *.dtd *.mod *.css
	newins "${FILESDIR}"/${P}.catalog catalog

	insinto /usr/share/sgml/docbook/${P#docbook-}/ent
	doins ent/*.ent

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

	# See bug #816303 for rationale behind die
	build-docbook-catalog || die "Failed to regenerate docbook catalog. Is /run mounted?"
	sgml-catalog-r1_pkg_postinst
}

pkg_postrm() {
	# See bug #816303 for rationale behind die
	build-docbook-catalog || die "Failed to regenerate docbook catalog. Is /run mounted?"
	sgml-catalog-r1_pkg_postrm
}
