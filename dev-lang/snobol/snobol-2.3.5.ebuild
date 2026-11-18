# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit flag-o-matic toolchain-funcs

MY_P="${PN}4-${PV}"
DESCRIPTION="Phil Budne's port of Macro SNOBOL4 in C, for modern machines"
HOMEPAGE="https://www.regressive.org/snobol4/"
SRC_URI="https://ftp.regressive.org/snobol4/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc tcl"
DEPEND="
	app-arch/bzip2
	app-arch/xz-utils
	dev-db/sqlite
	dev-libs/openssl
	sys-libs/gdbm[berkdb]
	sys-libs/ncurses
	sys-libs/readline
	tcl? ( dev-lang/tcl )
"
RDEPEND="${DEPEND}"
BDEPEND="
	sys-devel/m4
	virtual/pkgconfig
"

src_prepare() {
	default
	filter-lto
}

src_configure() {
	local myconf=()
	tc-export CC
	# Flags needed to get a clean build
	append-flags -Wno-unused-result -fno-strict-aliasing -Wno-implicit-function-declaration
	# Needed for time related functions
	append-cppflags -D_XOPEN_SOURCE=700

	if use doc; then
		myconf+=(--with-docs)
	else
		myconf+=(--without-docs)
	fi
	if use tcl; then
		myconf+=( --with-tcl=/usr/$get_libdir/tclConfig.sh )
	fi

	./configure --prefix="${EPREFIX}/usr" \
		--snolibdir="${EPREFIX}/usr/lib/snobol4" \
		--mandir="${EPREFIX}/usr/share/man" \
		--add-cflags="${CFLAGS}" \
		"${myconf[@]}" || die
}
src_compile() {
	emake build_all
}
src_install() {
	emake DESTDIR="${D}" install_notiming

	# Bug 789639 / 655746
	mv "${ED}/usr/bin/sdb" "${ED}/usr/bin/snoboldb"
	rename sdb snoboldb "${ED}/usr/share/man/man1/"*

	rm "${ED}"/usr/lib/snobol4/${PV}/README || die
	if use doc; then
		mv "${ED}/usr/share/doc/snobol4-${PV}" "${ED}/usr/share/doc/${PF}" || die
		rename sdb snoboldb "${ED}/usr/share/doc/${PF}/"*
	else
		rm -rf "${ED}/usr/share/doc/snobol4-${PV}"
	fi
}

pkg_postinst() {
	elog "CSNOBOL4 installed as snobol4"
	elog " Note: To avoid package collision the snobol debugger, sdb,"
	elog "       is installed as snoboldb"
}
