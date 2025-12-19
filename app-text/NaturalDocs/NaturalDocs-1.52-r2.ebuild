# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

DESCRIPTION="Extensible, multi-language source code documentation generator"
HOMEPAGE="http://www.naturaldocs.org/"
SRC_URI="https://downloads.sourceforge.net/naturaldocs/${P}.zip"
S="${WORKDIR}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ppc ppc64 ~riscv ~sparc x86"

BDEPEND="app-arch/unzip"

src_install() {
	insinto /usr/share/${PN}
	doins -r Styles Info JavaScript

	insinto /etc/${PN}
	doins -r Config/.
	dosym ../../../etc/${PN} /usr/share/${PN}/Config

	perl_set_version
	insinto ${VENDOR_LIB#${EPREFIX}}
	doins -r Modules/NaturalDocs
	dodir /usr/share/${PN}/Modules
	dosym ../../../..${VENDOR_LIB#${EPREFIX}}/NaturalDocs /usr/share/${PN}/Modules/NaturalDocs

	exeinto /usr/share/${PN}
	doexe ${PN}

	# Symlink the Perl script into /usr/bin
	dodir /usr/bin
	dosym ../share/${PN}/${PN} /usr/bin/${PN}

	# Documentation
	dodoc -r Help/.
	dosym ../doc/${PF}/html /usr/share/${PN}/Help
}

pkg_preinst() {
	if [[ -e "${EROOT}"/usr/share/${PN}/Config && ! -L "${EROOT}"/usr/share/${PN}/Config ]] ; then
		mkdir -p "${EROOT}"/etc/${PN}
		mv "${EROOT}"/usr/share/${PN}/Config/* "${EROOT}"/etc/${PN}/
		rm -rf "${EROOT}"/usr/share/${PN}/Config
	fi
}
