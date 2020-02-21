# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

WEBAPP_MANUAL_SLOT="yes"

inherit webapp eutils multilib user toolchain-funcs

[[ -z "${CGIT_CACHEDIR}" ]] && CGIT_CACHEDIR="/var/cache/${PN}/"

GIT_V="2.25.0"

DESCRIPTION="a fast web-interface for git repositories"
HOMEPAGE="https://git.zx2c4.com/cgit/about"
SRC_URI="https://www.kernel.org/pub/software/scm/git/git-${GIT_V}.tar.xz
	https://git.zx2c4.com/cgit/snapshot/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="doc +highlight libressl +lua +jit"

RDEPEND="
	dev-vcs/git
	sys-libs/zlib
	virtual/httpd-cgi
	highlight? ( || ( dev-python/pygments app-text/highlight ) )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	lua? ( jit? ( dev-lang/luajit ) !jit? ( dev-lang/lua:0 ) )
"
# ebuilds without WEBAPP_MANUAL_SLOT="yes" are broken
DEPEND="${RDEPEND}
	!<www-apps/cgit-0.8.3.3
	doc? ( app-text/docbook-xsl-stylesheets
		>=app-text/asciidoc-8.5.1 )
"

pkg_setup() {
	webapp_pkg_setup
	enewgroup ${PN}
	enewuser ${PN} -1 -1 -1 ${PN}
}

src_prepare() {
	rmdir git || die
	mv "${WORKDIR}"/git-"${GIT_V}" git || die

	echo "prefix = ${EPREFIX}/usr" >> cgit.conf
	echo "libdir = ${EPREFIX}/usr/$(get_libdir)" >> cgit.conf
	echo "CGIT_SCRIPT_PATH = ${MY_CGIBINDIR}" >> cgit.conf
	echo "CGIT_DATA_PATH = ${MY_HTDOCSDIR}" >> cgit.conf
	echo "CACHE_ROOT = ${CGIT_CACHEDIR}" >> cgit.conf
	echo "DESTDIR = ${D}" >> cgit.conf
	if use lua; then
		if use jit; then
			echo "LUA_PKGCONFIG = luajit" >> cgit.conf
		else
			echo "LUA_PKGCONFIG = lua" >> cgit.conf
		fi
	else
		echo "NO_LUA = 1" >> cgit.conf
	fi
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

pkg_postinst() {
	webapp_pkg_postinst
	ewarn "If you intend to run cgit using web server's user"
	ewarn "you should change ${CGIT_CACHEDIR} permissions."
}
