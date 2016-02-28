# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils pam toolchain-funcs

DESCRIPTION="Concurrent Versions System - source code revision control tools"
HOMEPAGE="http://www.nongnu.org/cvs/"

SRC_URI="mirror://gnu/non-gnu/cvs/source/feature/${PV}/${P}.tar.bz2
	doc? ( mirror://gnu/non-gnu/cvs/source/feature/${PV}/cederqvist-${PV}.html.tar.bz2
		mirror://gnu/non-gnu/cvs/source/feature/${PV}/cederqvist-${PV}.pdf
		mirror://gnu/non-gnu/cvs/source/feature/${PV}/cederqvist-${PV}.ps )"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~sparc-fbsd ~x86-fbsd"

IUSE="crypt doc kerberos nls pam server"
RESTRICT='test'

DEPEND=">=sys-libs/zlib-1.1.4
	kerberos? ( virtual/krb5 )
	pam? ( virtual/pam )"

src_unpack() {
	unpack ${P}.tar.bz2
	use doc && unpack cederqvist-${PV}.html.tar.bz2
	EPATCH_OPTS="-p1 -d ${S}" epatch "${FILESDIR}"/${P}-cvsbug-tmpfix.patch
	epatch "${FILESDIR}"/${P}-openat.patch
	EPATCH_OPTS="-p1 -d ${S}" epatch "${FILESDIR}"/${P}-block-requests.patch
	cd "${S}"
	epatch "${FILESDIR}"/${P}-cvs-gnulib-vasnprintf.patch
	epatch "${FILESDIR}"/${P}-install-sh.patch
	epatch "${FILESDIR}"/${P}-mktime-x32.patch # 395641
	epatch "${FILESDIR}"/${P}-mktime-configure.patch #220040 #570208
	use server || elog "If you want any CVS server functionality, you MUST emerge with USE=server!"
}

src_compile() {
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
		|| die
	emake || die "emake failed"
}

src_install() {
	emake install DESTDIR="${D}" || die

	insinto /etc/xinetd.d
	newins "${FILESDIR}"/cvspserver.xinetd.d cvspserver || die "newins failed"

	dodoc BUGS ChangeLog* DEVEL* FAQ HACKING \
		MINOR* NEWS PROJECTS README* TESTS TODO

	# Not installed into emacs site-lisp because it clobbers the normal C
	# indentations.
	dodoc cvs-format.el || die "dodoc failed"

	use server && newdoc "${FILESDIR}"/cvs-1.12.12-cvs-custom.c cvs-custom.c

	if use doc; then
		dodoc "${DISTDIR}"/cederqvist-${PV}.pdf
		dodoc "${DISTDIR}"/cederqvist-${PV}.ps
		tar xjf "${DISTDIR}"/cederqvist-${PV}.html.tar.bz2
		dohtml -r cederqvist-${PV}.html/*
		cd "${D}"/usr/share/doc/${PF}/html/
		ln -s cvs.html index.html
	fi

	newpamd "${FILESDIR}"/cvs.pam-include-1.12.12 cvs
}
