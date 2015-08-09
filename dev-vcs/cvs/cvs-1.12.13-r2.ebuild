# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils pam toolchain-funcs

DESCRIPTION="Concurrent Versions System - source code revision control tools"
HOMEPAGE="http://www.nongnu.org/cvs/"

SRC_URI="mirror://gnu/non-gnu/cvs/source/feature/${PV}/${P}.tar.bz2
	doc? ( mirror://gnu/non-gnu/cvs/source/feature/${PV}/cederqvist-${PV}.html.tar.bz2
		mirror://gnu/non-gnu/cvs/source/feature/${PV}/cederqvist-${PV}.pdf
		mirror://gnu/non-gnu/cvs/source/feature/${PV}/cederqvist-${PV}.ps )"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="crypt doc emacs kerberos nls pam server"

DEPEND=">=sys-libs/zlib-1.1.4
		kerberos? ( virtual/krb5 )
		pam? ( virtual/pam )"

src_unpack() {
	unpack ${P}.tar.bz2
	use doc && unpack cederqvist-${PV}.html.tar.bz2
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.12.12-cvsbug-tmpfix.patch
	epatch "${FILESDIR}"/${P}-openat.patch
	epatch "${FILESDIR}"/${P}-zlib.patch
	epatch "${FILESDIR}"/${PN}-1.12.12-install-sh.patch
	epatch "${FILESDIR}"/${PN}-1.12.12-fix-massive-leak.patch
	# this testcase was not updated
	#sed -i.orig -e '/unrecognized keyword.*BogusOption/s,98,73,g' \
	#  ${S}/src/sanity.sh
	# this one fails when the testpath path contains '.'
	sed -i.orig -e '/newfile config3/s,a-z,a-z.,g' \
	  "${S}"/src/sanity.sh
}

src_configure() {
	local myconf
	# the tests need the server and proxy
	if use test; then
		use server || \
		ewarn "The server and proxy code are enabled as they are required for tests."
		myconf="--enable-server --enable-proxy"
	fi
	if tc-is-cross-compiler ; then
		# Sane defaults when cross-compiling (as these tests want to
		# try and execute code).
		export cvs_cv_func_printf_ptr="yes"
	fi
	econf \
		--with-external-zlib \
		--with-tmpdir=/tmp \
		$(use_enable crypt encryption) \
		$(use_with kerberos gssapi) \
		$(use_enable nls) \
		$(use_enable pam) \
		$(use_enable server) \
		$(use_enable server proxy)
}

src_install() {
	einstall || die

	if use server; then
	  insinto /etc/xinetd.d
	  newins "${FILESDIR}"/cvspserver.xinetd.d cvspserver || die "newins failed"
	fi

	dodoc BUGS ChangeLog* DEVEL* FAQ HACKING \
		MINOR* NEWS PROJECTS README* TESTS TODO

	if use emacs; then
		insinto /usr/share/emacs/site-lisp
		doins cvs-format.el || die "doins failed"
	fi

	if use doc; then
		dodoc "${DISTDIR}"/cederqvist-${PV}.pdf
		dodoc "${DISTDIR}"/cederqvist-${PV}.ps
		tar xjf "${DISTDIR}"/cederqvist-${PV}.html.tar.bz2
		dohtml -r cederqvist-${PV}.html/*
		dosym cvs.html /usr/share/doc/${PF}/html/index.html
	fi

	newpamd "${FILESDIR}"/cvs.pam-include-1.12.12 cvs
}

src_test() {
	einfo "If you want to see realtime status, or check out a failure,"
	einfo "please look at ${S}/src/check.log*"
	if [ -n "$TEST_REMOTE_AND_PROXY" ]; then
		einfo "local, remote, and proxy tests enabled."
	else
		einfo "Only testing local mode. Please see ebuild for other modes."
	fi

	cd "${S}"/src
	export TESTDIR="${T}/tests-local"
	mkdir -p "$TESTDIR"
	# we only do the local tests by default
	make localcheck || die "Some local test failed."
	mv -f check.log check.log-local

	# if you want to test the remote and proxy modes, things get a little bit
	# complicated. You need to set up a SSH config file at ~portage/.ssh/config
	# that allows the portage user to login without any authentication, and also
	# set up the ~portage/.ssh/known_hosts file for your machine.
	# We do not do this by default, as it is unsafe from a security point of
	# view, and requires root level ssh changes.
	if [ -n "$TEST_REMOTE_AND_PROXY" ]; then
		cd "${S}"/src
		export TESTDIR="${T}/tests-remote"
		mkdir -p "$TESTDIR"
		make remotecheck || die "Some remote test failed."
		mv -f check.log check.log-remote

		cd "${S}"/src
		export TESTDIR="${T}/tests-proxy"
		mkdir -p "$TESTDIR"
		make proxycheck || die "Some proxy test failed."
		mv -f check.log check.log-proxy
	fi
}
