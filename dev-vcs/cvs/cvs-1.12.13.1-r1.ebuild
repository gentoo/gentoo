# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils pam toolchain-funcs versionator

DESCRIPTION="Concurrent Versions System - source code revision control tools"
HOMEPAGE="http://www.nongnu.org/cvs/"

DOC_PV="$(get_version_component_range 1-3)"
FEAT_URIBASE="mirror://gnu/non-gnu/cvs/source/feature/${PV}/"
DOC_URIBASE="mirror://gnu/non-gnu/cvs/source/feature/${DOC_PV}/"
SNAP_URIBASE="mirror://gnu/non-gnu/cvs/source/nightly-snapshots/feature/"
SRC_URI="
	${FEAT_URIBASE}/${P}.tar.bz2
	${SNAP_URIBASE}/${P}.tar.bz2
	doc? (
		${DOC_URIBASE}/cederqvist-${DOC_PV}.html.tar.bz2
		${DOC_URIBASE}/cederqvist-${DOC_PV}.pdf
		${DOC_URIBASE}/cederqvist-${DOC_PV}.ps
		)"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~ppc-aix ~sparc-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

IUSE="crypt doc kerberos nls pam server"

RDEPEND=">=sys-libs/zlib-1.1.4
		kerberos? ( virtual/krb5 )
		pam? ( virtual/pam )"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${P}.tar.bz2
	use doc && unpack cederqvist-${DOC_PV}.html.tar.bz2
}

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.12.12-cvsbug-tmpfix.patch
	epatch "${FILESDIR}"/${PN}-1.12.12-install-sh.patch
	epatch "${FILESDIR}"/${PN}-1.12.13.1-block-requests.patch
	epatch "${FILESDIR}"/${PN}-1.12.13.1-hash-nameclash.patch # for AIX
	epatch "${FILESDIR}"/${PN}-1.12.13.1-gl-mempcpy.patch # for AIX
	epatch "${FILESDIR}"/${PN}-1.12.12-fix-massive-leak.patch
	epatch "${FILESDIR}"/${PN}-1.12.13.1-use-include_next.patch
	# Applied by upstream:
	#epatch "${FILESDIR}"/${PN}-1.12.13-openat.patch
	#epatch "${FILESDIR}"/${PN}-1.12.13-zlib.patch

	# this testcase was not updated
	#sed -i.orig -e '/unrecognized keyword.*BogusOption/s,98,73,g' \
	#  ${S}/src/sanity.sh
	# this one fails when the testpath path contains '.'
	sed -i.orig \
		-e '/newfile config3/s,a-z,a-z.,g' \
		"${S}"/src/sanity.sh

	elog "If you want any CVS server functionality, you MUST emerge with USE=server!"
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
		$(use_enable server proxy) \
		${myconf}
}

src_install() {
	emake install DESTDIR="${D}" || die

	if use server; then
	  insinto /etc/xinetd.d
	  newins "${FILESDIR}"/cvspserver.xinetd.d cvspserver || die "newins failed"
	fi

	dodoc BUGS ChangeLog* DEVEL* FAQ HACKING \
		MINOR* NEWS PROJECTS README* TESTS TODO

	# Not installed into emacs site-lisp because it clobbers the normal C
	# indentations.
	dodoc cvs-format.el || die "dodoc failed"

	use server && newdoc "${FILESDIR}"/${PN}-1.12.12-cvs-custom.c cvs-custom.c

	if use doc; then
		dodoc "${DISTDIR}"/cederqvist-${DOC_PV}.pdf
		dodoc "${DISTDIR}"/cederqvist-${DOC_PV}.ps
		dohtml -r "${WORKDIR}"/cederqvist-${DOC_PV}.html/
		dosym cvs.html /usr/share/doc/${PF}/html/index.html
	fi

	newpamd "${FILESDIR}"/cvs.pam-include-1.12.12 cvs
}

_run_one_test() {
	mode="$1" ; shift
	einfo "Starting ${mode} test"
	cd "${S}"/src
	export TESTDIR="${T}/tests-${mode}"
	rm -rf "$TESTDIR" # Clean up from any previous test passes
	mkdir -p "$TESTDIR"
	emake -j1 ${mode}check || die "Some ${mode} test failed."
	mv -f check.log check.log-${mode}
	einfo "${mode} test completed successfully, log is check.log-${mode}"
}

src_test() {
	einfo "If you want to see realtime status, or check out a failure,"
	einfo "please look at ${S}/src/check.log*"

	if [ "$TEST_REMOTE_AND_PROXY" == "1" ]; then
		einfo "local, remote, and proxy tests enabled."
	else
		einfo "Only testing local mode. Please see ebuild for other modes."
	fi

	# we only do the local tests by default
	_run_one_test local

	# if you want to test the remote and proxy modes, things get a little bit
	# complicated. You need to set up a SSH config file at ~portage/.ssh/config
	# that allows the portage user to login without any authentication, and also
	# set up the ~portage/.ssh/known_hosts file for your machine.
	# We do not do this by default, as it is unsafe from a security point of
	# view, and requires root level ssh changes.
	# Note that this also requires having a real shell for the portage user, so make
	# sure that su -c 'ssh portage@mybox' portage works first!
	# (It uses the local ip, not loopback)
	if [ "$TEST_REMOTE_AND_PROXY" == "1" ]; then
		_run_one_test remote
		_run_one_test proxy
	fi
}
