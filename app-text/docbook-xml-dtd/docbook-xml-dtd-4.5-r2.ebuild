# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit sgml-catalog-r1

MY_P=${P/-dtd/}
DESCRIPTION="Docbook DTD for XML"
HOMEPAGE="https://docbook.org/"
SRC_URI="https://docbook.org/xml/${PV}/${MY_P}.zip"

LICENSE="docbook"
SLOT="${PV}"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND=">=app-text/docbook-xsl-stylesheets-1.65
	>=app-text/build-docbook-catalog-1.2"
DEPEND=">=app-arch/unzip-5.41"

S=${WORKDIR}

src_prepare() {
	# Prepend OVERRIDE directive
	sed -i -e '1i\\OVERRIDE YES' docbook.cat || die
	default
}

src_install() {
	keepdir /etc/xml

	insinto "/usr/share/sgml/docbook/xml-dtd-${PV}"
	doins *.cat *.dtd *.mod *.xml
	insinto "/usr/share/sgml/docbook/xml-dtd-${PV}/ent"
	doins ent/*.ent

	insinto /etc/sgml
	newins - "xml-docbook-${PV}.cat" <<-EOF
		CATALOG "${EPREFIX}/etc/sgml/sgml-docbook.cat"
		CATALOG "${EPREFIX}/usr/share/sgml/docbook/xml-dtd-${PV}/docbook.cat"
	EOF

	cp ent/README README.ent
	dodoc ChangeLog README*
}

pkg_preinst() {
	# work-around old revision removing it
	cp "${ED}"/etc/sgml/xml-docbook-${PV}.cat "${T}" || die
}

pkg_postinst() {
	local backup=${T}/xml-docbook-${PV}.cat
	local real=${EROOT}/etc/sgml/xml-docbook-${PV}.cat

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
