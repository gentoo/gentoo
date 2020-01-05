# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

PYTHON_COMPAT=( python2_7 )

inherit user autotools systemd python-r1

DESCRIPTION="Varnish is a state-of-the-art, high-performance HTTP accelerator"
HOMEPAGE="https://varnish-cache.org/"
SRC_URI="http://varnish-cache.org/_downloads/${P}.tgz"

LICENSE="BSD-2 GPL-2"
SLOT="0"
KEYWORDS="amd64 ~mips ~ppc ~ppc64 x86"
IUSE="jemalloc jit static-libs"

CDEPEND="
	sys-libs/readline:0=
	dev-libs/libpcre[jit?]
	jemalloc? ( dev-libs/jemalloc )
	sys-libs/ncurses:0="

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

pkg_setup() {
	ebegin "Creating varnish user and group"
	enewgroup varnish
	enewuser varnish -1 -1 /var/lib/varnish varnish
	eend $?
}

src_prepare() {
	# Remove bundled libjemalloc. We also fix
	# automagic dep in our patches, bug #461638
	rm -rf lib/libjemalloc

	# Fix bug #620952
	eapply "${FILESDIR}"/fix-build-x86.patch

	# Remove -Werror bug #528354
	sed -i -e 's/-Werror\([^=]\)/\1/g' configure.ac

	eapply_user

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_enable jit pcre-jit ) \
		$(use_with jemalloc)
}

src_install() {
	emake DESTDIR="${D}" install

	python_replicate_script "${D}/usr/share/varnish/vmodtool.py"

	newinitd "${FILESDIR}"/varnishlog.initd varnishlog
	newconfd "${FILESDIR}"/varnishlog.confd varnishlog

	newinitd "${FILESDIR}"/varnishncsa.initd varnishncsa
	newconfd "${FILESDIR}"/varnishncsa.confd varnishncsa

	newinitd "${FILESDIR}"/varnishd.initd-r4 varnishd
	newconfd "${FILESDIR}"/varnishd.confd-r4 varnishd

	insinto /etc/logrotate.d/
	newins "${FILESDIR}/varnishd.logrotate-r2" varnishd

	diropts -m750

	dodir /var/log/varnish/

	systemd_dounit "${FILESDIR}/${PN}d.service"

	insinto /etc/varnish/
	doins lib/libvmod_std/vmod.vcc
	doins etc/example.vcl

	dodoc README.rst
	dodoc doc/changes.rst

	fowners root:varnish /etc/varnish/
	fowners varnish:varnish /var/lib/varnish/
	fperms 0750 /var/lib/varnish/ /etc/varnish/
}
