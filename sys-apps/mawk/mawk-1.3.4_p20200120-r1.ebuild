# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

MY_P="${P/_p/-}"
DESCRIPTION="An (often faster than gawk) awk-interpreter"
HOMEPAGE="https://invisible-island.net/mawk/mawk.html"
SRC_URI="https://invisible-mirror.net/archives/${PN}/${MY_P}.tgz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"

DOCS=( ACKNOWLEDGMENT CHANGES README )

src_configure() {
	tc-export BUILD_CC
	econf
}

src_install() {
	default

	exeinto /usr/share/doc/${PF}/examples
	doexe examples/*
	docompress -x /usr/share/doc/${PF}/examples
}

pkg_postinst() {
	if has_version app-admin/eselect && has_version app-eselect/eselect-awk
	then
		eselect awk update ifunset
	fi
}

pkg_postrm() {
	if has_version app-admin/eselect && has_version app-eselect/eselect-awk
	then
		eselect awk update ifunset
	fi
}
