# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="2"
inherit eutils multilib toolchain-funcs user

DESCRIPTION="Yet another Dictionary server for the SKK Japanese-input software"
HOMEPAGE="https://dbskkd-cdb.googlecode.com/"
SRC_URI="https://dbskkd-cdb.googlecode.com/files/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="|| ( dev-db/cdb dev-db/tinycdb )"
RDEPEND=">=app-i18n/skk-jisyo-200705[cdb]
	sys-apps/xinetd"

pkg_setup() {
	enewuser dbskkd -1 -1 -1
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-gentoo.patch

	local cdblib=()
	if has_version dev-db/cdb; then
		append-cflags -I"${EPREFIX}"/usr/include/cdb
		local a
		for a in cdb.a alloc.a buffer.a byte.a unix.a; do
			cdblib+=( "${EPREFIX}"/usr/$(get_libdir)/${a} )
		done
	else
		cdblib+=( -lcdb )
	fi

	sed -i "/^CDBLIB/s|=.*$|= ${cdblib[*]}|" Makefile
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		COMPAT="-DJISYO_FILE=\\\"${EPREFIX}/usr/share/skk/SKK-JISYO.L.cdb\\\"" \
		|| die
}

src_install() {
	exeinto /usr/libexec
	doexe ${PN}

	insinto /etc/xinetd.d
	newins "${FILESDIR}/${PN}.xinetd" ${PN} || die

	dodoc CHANGES README* *.txt
}
