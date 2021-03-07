# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LUA_COMPAT=( lua5-{1..2} luajit )
WEBAPP_MANUAL_SLOT="yes"

inherit git-r3 lua-single toolchain-funcs webapp

[[ -z "${CGIT_CACHEDIR}" ]] && CGIT_CACHEDIR="/var/cache/${PN}/"

DESCRIPTION="a fast web-interface for git repositories"
HOMEPAGE="https://git.zx2c4.com/cgit/about"
SRC_URI=""
EGIT_REPO_URI="https://git.zx2c4.com/cgit"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="doc +highlight libressl +lua test"
REQUIRED_USE="lua? ( ${LUA_REQUIRED_USE} )"
RESTRICT="!test? ( test )"

RDEPEND="
	acct-group/cgit
	acct-user/cgit
	dev-vcs/git
	highlight? ( || ( dev-python/pygments app-text/highlight ) )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	lua? ( ${LUA_DEPS} )
	sys-libs/zlib
	virtual/httpd-cgi
"
# ebuilds without WEBAPP_MANUAL_SLOT="yes" are broken
DEPEND="${RDEPEND}
	doc? ( app-text/docbook-xsl-stylesheets
		>=app-text/asciidoc-8.5.1 )
"

pkg_setup() {
	webapp_pkg_setup
	use lua && lua-single_pkg_setup
}

src_prepare() {
	echo "prefix = ${EPREFIX}/usr" >> cgit.conf
	echo "libdir = ${EPREFIX}/usr/$(get_libdir)" >> cgit.conf
	echo "CGIT_SCRIPT_PATH = ${MY_CGIBINDIR}" >> cgit.conf
	echo "CGIT_DATA_PATH = ${MY_HTDOCSDIR}" >> cgit.conf
	echo "CACHE_ROOT = ${CGIT_CACHEDIR}" >> cgit.conf
	echo "DESTDIR = ${D}" >> cgit.conf
	if use lua; then
		echo "LUA_PKGCONFIG = ${ELUA}" >> cgit.conf
	else
		echo "NO_LUA = 1" >> cgit.conf
	fi

	eapply_user
}

src_compile() {
	emake V=1 AR="$(tc-getAR)" CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}"
	use doc && emake V=1 doc-man
}

src_install() {
	webapp_src_preinst

	emake V=1 AR="$(tc-getAR)" CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" install

	insinto /etc
	doins "${FILESDIR}"/cgitrc

	dodoc README
	use doc && doman cgitrc.5

	webapp_postinst_txt en "${FILESDIR}"/postinstall-en.txt
	webapp_src_install

	keepdir "${CGIT_CACHEDIR}"
	fowners ${PN}:${PN} "${CGIT_CACHEDIR}"
	fperms 700 "${CGIT_CACHEDIR}"
}

src_test() {
	emake V=1 AR="$(tc-getAR)" CC="$(tc-getCC)" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" test
}

pkg_postinst() {
	webapp_pkg_postinst
	ewarn "If you intend to run cgit using web server's user"
	ewarn "you should change ${CGIT_CACHEDIR} permissions."
}
