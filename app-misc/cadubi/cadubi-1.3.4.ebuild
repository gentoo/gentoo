# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An application that allows you to draw ASCII-Art images"
HOMEPAGE="https://github.com/statico/cadubi"
SRC_URI="https://github.com/statico/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~amd64 ppc ppc64 x86"

RDEPEND="dev-lang/perl
	>=dev-perl/TermReadKey-2.21"

src_prepare() {
	default
	sed -i "s|$Bin/help.txt|$Bin/../$(get_libdir)/${PN}/help.txt|g" ${PN} || die
}

src_install() {
	dobin ${PN}
	doman ${PN}.1
	insinto /usr/$(get_libdir)/${PN}
	doins help.txt
	dodoc README.md
}
