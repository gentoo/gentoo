# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..12} )

inherit autotools systemd python-r1

DESCRIPTION="Varnish is a state-of-the-art, high-performance HTTP accelerator"
HOMEPAGE="https://varnish-cache.org/"
SRC_URI="http://varnish-cache.org/_downloads/${P}.tgz"

LICENSE="BSD-2 GPL-2"
SLOT="0/2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
# From Fedora:
# Default: Use jemalloc, as adviced by upstream project
IUSE="+jemalloc jit selinux static-libs unwind"

CDEPEND="
	sys-libs/readline:=
	dev-libs/libedit
	dev-libs/libpcre2[jit?]
	sys-libs/ncurses:=
	jemalloc? ( dev-libs/jemalloc:= )
	unwind? ( sys-libs/libunwind:= )
"

# varnish compiles stuff at run time
RDEPEND="
	${PYTHON_DEPS}
	${CDEPEND}
	acct-user/varnish
	acct-group/varnish
	sys-devel/gcc
	selinux? ( sec-policy/selinux-varnishd )
"
DEPEND="
	${CDEPEND}
	dev-python/docutils
	dev-python/sphinx
	virtual/pkgconfig
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=( "${FILESDIR}/${PN}-7.1.2-disable-tests.patch" )

src_prepare() {
	default

	# Remove -Werror bug #528354
	sed -i -e 's/-Werror\([^=]\)/\1/g' configure.ac || die

	# Upstream doesn't put varnish.m4 in the m4/ directory
	# We link because the Makefiles look for the file in
	# the original location
	ln -sf ../varnish.m4 m4/varnish.m4 || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--with-contrib
		$(use_enable static-libs static)
		$(use_enable jit pcre2-jit)
		$(use_with jemalloc)
		$(use_with unwind)
	)
	econf "${myeconfargs[@]}"
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

	keepdir /var/lib/varnish
	keepdir /var/log/varnish

	systemd_dounit "${FILESDIR}/${PN}d.service"

	insinto /etc/varnish/
	doins vmod/vmod_*.vcc
	doins etc/example.vcl

	dodoc README.rst
	dodoc doc/changes.rst

	fowners root:varnish /etc/varnish/
	fowners varnish:varnish /var/lib/varnish/
	fperms 0750 /var/lib/varnish/ /etc/varnish/

	find "${ED}" -name "*.la" -delete || die
}
