# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"
inherit flag-o-matic eutils

DESCRIPTION="Useful Apache tools - htdigest, htpasswd, ab, htdbm"
HOMEPAGE="http://httpd.apache.org/"
SRC_URI="mirror://apache/httpd/httpd-${PV}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 hppa ia64 ~mips ~ppc ppc64 ~s390 ~sh ~sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd"
IUSE="ssl"
RESTRICT="test"

RDEPEND="=dev-libs/apr-1*
	=dev-libs/apr-util-1*
	dev-libs/expat
	dev-libs/libpcre
	kernel_linux? ( sys-apps/util-linux )
	ssl? ( dev-libs/openssl )
	!<www-servers/apache-2.2.4"

DEPEND="${RDEPEND}
	sys-devel/libtool"

S="${WORKDIR}/httpd-${PV}"

src_prepare() {
	# Apply these patches:
	# (1)	apache-tools-2.2.20-Makefile.patch:
	#		- fix up the `make install' for support/
	#		- remove envvars from `make install'
	epatch "${FILESDIR}"/${PN}-2.2.20-Makefile.patch
}

src_configure() {
	# Brain dead check.
	tc-is-cross-compiler && export ap_cv_void_ptr_lt_long="no"

	# Instead of filtering --as-needed (bug #128505), append --no-as-needed
	append-ldflags $(no-as-needed)

	# econf overwrites the stuff from config.layout.
	econf \
		--sbindir=/usr/sbin \
		--with-z=/usr \
		--with-apr=/usr \
		--with-apr-util=/usr \
		--with-pcre=/usr \
		$(use_enable ssl) \
		$(usex ssl '--with-ssl=/usr' '')
}

src_compile() {
	cd support || die
	emake
}

src_install () {
	cd support || die

	make DESTDIR="${D}" install || die

	# install manpages
	doman "${S}"/docs/man/{dbmmanage,htdigest,htpasswd,htdbm}.1 \
		"${S}"/docs/man/{htcacheclean,rotatelogs,ab,logresolve}.8

	# Providing compatiblity symlinks for #177697 (which we'll stop to install
	# at some point).
	pushd "${D}"/usr/sbin/ >/dev/null || die
	for i in *; do
		dosym /usr/sbin/${i} /usr/sbin/${i}2
	done
	popd >/dev/null || die

	# Provide a symlink for ab-ssl
	if use ssl; then
		dosym /usr/sbin/ab /usr/sbin/ab-ssl
		dosym /usr/sbin/ab /usr/sbin/ab2-ssl
	fi

	# make htpasswd accessible for non-root users
	dosym /usr/sbin/htpasswd /usr/bin/htpasswd
	dosym /usr/sbin/htdigest /usr/bin/htdigest

	dodoc "${S}"/CHANGES
}
