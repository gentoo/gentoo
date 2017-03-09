# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit perl-functions flag-o-matic readme.gentoo-r1

MY_GITV="${PV}"

DESCRIPTION="Generated .ph equivalents of system headers"
HOMEPAGE="https://github.com/gentoo-perl/${PN}"
SRC_URI="https://github.com/gentoo-perl/${PN}/archive/${MY_GITV}.tar.gz -> ${PN}-${MY_GITV}.tar.gz"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+debug +sizeof-warning"

RDEPEND="dev-lang/perl:="
DEPEND="${RDEPEND}
	sys-kernel/linux-headers
"

S="${WORKDIR}/${PN}-${MY_GITV}"

src_compile() {
	use sizeof-warning && append-cppflags "-DSIZEOF_WARNING=1"
	emake H2PHARGS="$(usex debug " -h" "")"
}

src_install() {
	readme.gentoo_create_doc
	perl_set_version
	insinto "${ARCH_LIB}"
	doins -r "${S}/headers/"*
	doins -r "${S}/appended/"*

}

pkg_postinst() {
	readme.gentoo_print_elog
}
