# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/thomasdickey.asc
inherit toolchain-funcs verify-sig

MY_P="${P/_p/-}"
DESCRIPTION="An (often faster than gawk) awk-interpreter"
HOMEPAGE="https://invisible-island.net/mawk/mawk.html"
SRC_URI="https://invisible-mirror.net/archives/${PN}/${MY_P}.tgz"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/${PN}/${MY_P}.tgz.asc )"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
# See NOTE: at top of CHANGES, so unkeyworded for now:
# """
#	The regular expression changes begun in 2020 are incomplete, e.g., do
#	not handle a mixture of grouping and brace expressions.  Fixing that
#	issue is needed before a new stable release.
# """
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-thomasdickey )"

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
	if has_version app-admin/eselect && has_version app-eselect/eselect-awk; then
		eselect awk update ifunset
	fi
}

pkg_postrm() {
	if has_version app-admin/eselect && has_version app-eselect/eselect-awk; then
		eselect awk update ifunset
	fi
}
