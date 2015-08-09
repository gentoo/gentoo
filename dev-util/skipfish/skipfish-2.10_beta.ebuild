# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs versionator

MY_P="$PN-$(get_version_component_range 1-2)b"

DESCRIPTION="A fully automated, active web application security reconnaissance tool"
HOMEPAGE="http://code.google.com/p/skipfish/"
SRC_URI="http://${PN}.googlecode.com/files/${MY_P}.tgz"

LICENSE="Apache-2.0 LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug"

RDEPEND="dev-libs/openssl:0
	dev-libs/libpcre
	net-dns/libidn
	sys-libs/zlib"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	sed -i \
		-e '/CFLAGS_GEN/s:-g -ggdb::' \
		-e '/CFLAGS_OPT/s:-O3::' \
		Makefile || die

	sed -i \
		-e "/ASSETS_DIR/s:assets:/usr/share/doc/${PF}/html:" \
		-e "/SIG_FILE/s:signatures/:/etc/skipfish/signatures/:" \
		src/config.h || die

	sed -i \
		-e "s:signatures/:/etc/skipfish/signatures/:g" \
		signatures/signatures.conf || die
}

src_compile() {
	tc-export CC

	local _debug
	use debug && _debug=debug

	emake ${_debug}
}

src_install() {
	dobin ${PN}
	doman doc/${PN}.1

	insinto /etc/skipfish
	doins -r signatures

	insinto /usr/share/${PN}/dictionaries
	doins dictionaries/*.wl

	dohtml assets/*

	dodoc ChangeLog README doc/*.txt
}
