# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )

inherit autotools systemd python-r1

DESCRIPTION="Varnish is a state-of-the-art, high-performance HTTP accelerator"
HOMEPAGE="https://vinyl-cache.org/"
SRC_URI="https://vinyl-cache.org/_downloads/${P}.tgz"

LICENSE="BSD-2 GPL-2"
SLOT="0/2"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~ppc64 ~riscv ~x86"
IUSE="jit selinux static-libs unwind"

COMMON_DEPEND="
	sys-libs/readline:=
	dev-libs/libedit
	dev-libs/libpcre2[jit?]
	sys-libs/ncurses:=
	unwind? ( sys-libs/libunwind:= )
"

# varnish compiles stuff at run time
RDEPEND="
	${PYTHON_DEPS}
	${COMMON_DEPEND}
	acct-user/varnish
	acct-group/varnish
	sys-devel/gcc
	selinux? ( sec-policy/selinux-varnishd )
"
DEPEND="
	${COMMON_DEPEND}
	dev-python/docutils
	dev-python/sphinx
	virtual/pkgconfig
"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

PATCHES=(
	"${FILESDIR}/${PN}-7.1.2-disable-tests.patch"
	"${FILESDIR}/${PN}-8.0.0-configure-make-python-output-match-autotools.patch" # Bug: 882725
)

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
		$(use_with unwind)
		--without-jemalloc
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	# Times out
	rm bin/varnishtest/tests/u00021.vtc || die

	default
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
