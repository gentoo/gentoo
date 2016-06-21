# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3} pypy )

inherit autotools-utils eutils systemd python-single-r1

DESCRIPTION="Varnish is a state-of-the-art, high-performance HTTP accelerator"
HOMEPAGE="http://www.varnish-cache.org/"
SRC_URI="http://repo.varnish-cache.org/source/${P}.tar.gz"

LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips x86"
IUSE="doc jemalloc jit static-libs +tools"

CDEPEND="
	|| ( dev-libs/libedit sys-libs/readline )
	dev-libs/libpcre[jit?]
	jemalloc? ( dev-libs/jemalloc )
	tools? ( sys-libs/ncurses:= )"

#varnish compiles stuff at run time
RDEPEND="
	${PYTHON_DEPS}
	${CDEPEND}
	sys-devel/gcc"

DEPEND="
	${CDEPEND}
	virtual/pkgconfig"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test" #315725

DOCS=( README doc/changes.rst )

PATCHES=(
	"${FILESDIR}"/${PN}-3.0.4-fix-automake-1.13.patch
	"${FILESDIR}"/${PN}-3.0.4-automagic.patch
	"${FILESDIR}"/${PN}-3.0.3-pthread-uclibc.patch
	"${FILESDIR}"/${PN}-3.0.5-fix-python-path.patch
	"${FILESDIR}"/${PN}-3.0.5-path-to-vmod_vcc.patch
)

AUTOTOOLS_AUTORECONF="yes"

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	# Remove bundled libjemalloc. We also fix
	# automagic dep in our patches, bug #461638
	rm -rf lib/libjemalloc

	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		$(use_enable static-libs static)
		$(use_enable jit pcre-jit )
		$(use_with jemalloc)
		$(use_with tools)
		--without-rst2man
		--without-rst2html
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	newinitd "${FILESDIR}"/varnishd.initd-r2 varnishd
	newconfd "${FILESDIR}"/varnishd.confd-r2 varnishd

	insinto /etc/logrotate.d
	newins "${FILESDIR}/varnishd.logrotate" varnishd

	dodir /var/log/varnish

	use doc && dohtml -r "doc/sphinx/=build/html/"

	systemd_dounit "${FILESDIR}/${PN}d.service"

	python_doscript lib/libvmod_std/vmod.py
	insinto /etc/varnish
	doins  lib/libvmod_std/vmod.vcc
}

pkg_postinst () {
	elog "No demo-/sample-configfile is included in the distribution.  Please"
	elog "read the man-page for more info.  A sample configuration proxying"
	elog "localhost:8080 for localhost:80 is given in /etc/conf.d/varnishd."
}
