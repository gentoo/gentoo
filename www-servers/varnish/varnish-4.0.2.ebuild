# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-servers/varnish/varnish-4.0.2.ebuild,v 1.2 2015/04/08 18:30:55 mgorny Exp $

EAPI="5"

PYTHON_COMPAT=( python{2_7,3_3} pypy )

inherit user autotools-utils eutils systemd python-r1

DESCRIPTION="Varnish is a state-of-the-art, high-performance HTTP accelerator"
HOMEPAGE="http://www.varnish-cache.org/"
SRC_URI="http://repo.varnish-cache.org/source/${P}.tar.gz"

LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~mips ~x86"
IUSE="jemalloc jit static-libs"

CDEPEND="
	|| ( dev-libs/libedit sys-libs/readline )
	dev-libs/libpcre[jit?]
	jemalloc? ( dev-libs/jemalloc )
	sys-libs/ncurses"

#varnish compiles stuff at run time
RDEPEND="
	${PYTHON_DEPS}
	${CDEPEND}
	sys-devel/gcc"

DEPEND="
	${CDEPEND}
	dev-python/docutils
	virtual/pkgconfig"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RESTRICT="test" #315725

DOCS=( README doc/changes.rst )

PATCHES=(
	"${FILESDIR}"/${PN}-4.0.1-fix-man-Makefile_am.patch
	"${FILESDIR}"/${PN}-4.0.1-fix-doc-Makefile_am.patch
	"${FILESDIR}"/${PN}-4.0.1-fix-warning.patch
)

AUTOTOOLS_AUTORECONF="yes"

pkg_setup() {
	ebegin "Creating varnish user and group"
	enewgroup varnish 40
	enewuser varnish 40 -1 /var/lib/varnish varnish
	eend $?
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
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	python_replicate_script "${D}/usr/share/varnish/vmodtool.py"

	newinitd "${FILESDIR}"/varnishlog.initd varnishlog
	newconfd "${FILESDIR}"/varnishlog.confd varnishlog

	newinitd "${FILESDIR}"/varnishncsa.initd-r1 varnishncsa
	newconfd "${FILESDIR}"/varnishncsa.confd varnishncsa

	newinitd "${FILESDIR}"/varnishd.initd-r3 varnishd
	newconfd "${FILESDIR}"/varnishd.confd-r3 varnishd

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/varnishd.logrotate-r2" varnishd

	diropts -m750

	dodir /var/log/varnish/

	systemd_dounit "${FILESDIR}/${PN}d.service"

	insinto /etc/varnish/
	doins lib/libvmod_std/vmod.vcc
	doins etc/example.vcl

	fowners root:varnish /etc/varnish/
	fowners varnish:varnish /var/lib/varnish/
	fperms 0750 /var/lib/varnish/ /etc/varnish/
}

pkg_postinst () {
	elog "No demo-/sample-configfile is included in the distribution.  Please"
	elog "read the man-page for more info.  A sample configuration proxying"
	elog "localhost:8080 for localhost:80 is given in /etc/conf.d/varnishd."
}
