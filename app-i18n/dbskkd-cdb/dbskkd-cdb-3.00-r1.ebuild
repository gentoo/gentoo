# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic toolchain-funcs

DESCRIPTION="SKK dictionary server based on cdb"
HOMEPAGE="https://github.com/jj1bdx/dbskkd-cdb"
SRC_URI="https://github.com/jj1bdx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="
	|| (
		dev-db/tinycdb
		dev-db/cdb
	)
"

RDEPEND="
	acct-group/dbskkd
	acct-user/dbskkd
	app-i18n/skk-jisyo[cdb]
	sys-apps/xinetd
"

PATCHES=( "${FILESDIR}"/${PN}-gentoo.patch )

src_prepare() {
	default

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
		COMPAT="-DJISYO_FILE=\\\"${EPREFIX}/usr/share/skk/SKK-JISYO.L.cdb\\\""
}

src_install() {
	exeinto /usr/libexec
	doexe dbskkd-cdb
	dodoc examples.md
	einstalldocs

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/dbskkd-cdb.xinetd dbskkd-cdb
}
