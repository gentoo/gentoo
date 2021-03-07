# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit flag-o-matic toolchain-funcs user

DESCRIPTION="SKK dictionary server based on cdb"
HOMEPAGE="https://github.com/jj1bdx/dbskkd-cdb"
SRC_URI="https://github.com/jj1bdx/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE=""

DEPEND="|| (
		dev-db/tinycdb
		dev-db/cdb
	)"
RDEPEND="app-i18n/skk-jisyo[cdb]
	sys-apps/xinetd"

PATCHES=( "${FILESDIR}"/${PN}-gentoo.patch )
DOCS="*.md"

pkg_setup() {
	enewuser dbskkd -1 -1 -1
}

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
	doexe ${PN}
	einstalldocs

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/${PN}.xinetd ${PN}
}
