# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit sgml-catalog-r1

DESCRIPTION="DTDs for the HyperText Markup Language 4.01"
HOMEPAGE="https://www.w3.org/TR/html401/"
SRC_URI="https://www.w3.org/TR/1999/REC-html401-19991224/html40.tgz"

LICENSE="W3C"
SLOT="0"
KEYWORDS="amd64 ppc ~s390 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

S=${WORKDIR}
PATCHES=( "${FILESDIR}"/${PN}-decl.diff )

src_install() {
	insinto /usr/share/sgml/${PN}
	doins HTML4.cat HTML4.decl *.dtd *.ent

	insinto /etc/sgml
	newins - html401.cat <<-EOF
		CATALOG "${EPREFIX}/usr/share/sgml/html401/HTML4.cat"
	EOF

	docinto html
	local dirs=( */ )
	dodoc -r *.html "${dirs[@]%/}"
}

pkg_preinst() {
	# work-around old revision removing it
	cp "${ED}"/etc/sgml/html401.cat "${T}" || die
}

pkg_postinst() {
	local backup=${T}/html401.cat
	local real=${EROOT}/etc/sgml/html401.cat
	if ! cmp -s "${backup}" "${real}"; then
		cp "${backup}" "${real}" || die
	fi
	sgml-catalog-r1_pkg_postinst
}
