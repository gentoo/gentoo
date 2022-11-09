# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit readme.gentoo-r1

MY_PV=${PV/./-}
MY_P=HyperSpec-${MY_PV}

DESCRIPTION="Common Lisp ANSI-standard Hyperspec"
HOMEPAGE="http://www.lispworks.com/reference/HyperSpec/"
SRC_URI="ftp://ftp.lispworks.com/pub/software_tools/reference/${MY_P}.tar.gz"
S="${WORKDIR}"

LICENSE="HyperSpec"
SLOT="0"
KEYWORDS="amd64 ~mips ppc ppc64 ~riscv sparc x86"

src_install() {
	docinto html
	dodoc -r HyperSpec/{Body,Data,Front,Graphics,Issues}
	dosym html /usr/share/doc/${PF}/HyperSpec
	dosym -r /usr/share/doc/${PF} /usr/share/${PN}

	docinto .
	dodoc HyperSpec-{README,Legalese}.text
	local DOC_CONTENTS="A permanent link to the HyperSpec documentation
		is provided at: ${EPREFIX}/usr/share/${PN}"
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
