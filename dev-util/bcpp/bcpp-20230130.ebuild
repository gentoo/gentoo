# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

VERIFY_SIG_OPENPGP_KEY_PATH="${BROOT}"/usr/share/openpgp-keys/thomasdickey.asc
inherit verify-sig

DESCRIPTION="Indents C/C++ source code"
HOMEPAGE="https://invisible-island.net/bcpp/"
SRC_URI="https://invisible-island.net/archives/${PN}/${P}.tgz"
SRC_URI+=" verify-sig? ( https://invisible-island.net/archives/${PN}/${P}.tgz.asc )"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"

BDEPEND="verify-sig? ( sec-keys/openpgp-keys-thomasdickey )"

src_compile() {
	emake CPPFLAGS='-DBCPP_CONFIG_DIR=\"/etc/bcpp/\"'
}

src_install() {
	default
	dodoc CHANGES MANIFEST README VERSION txtdocs/hirachy.txt \
		txtdocs/manual.txt

	insinto /etc/bcpp
	doins bcpp.cfg indent.cfg
}

pkg_postinst() {
	elog "Check the documentation for more information on how to"
	elog "Run bcpp.  Please note that in order to get help for"
	elog "bcpp, please run bcpp -h and not the command by itself."
	elog ""
	elog "Configuration files are at ${EPREFIX}/etc/bcpp."
	elog "To use them, use the -c option followed by the filename."
}
