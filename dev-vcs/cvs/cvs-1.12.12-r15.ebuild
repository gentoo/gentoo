# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools pam toolchain-funcs

DESCRIPTION="Concurrent Versions System - source code revision control tools"
HOMEPAGE="https://cvs.nongnu.org/"

SRC_URI="mirror://gnu/non-gnu/cvs/source/feature/${PV}/${P}.tar.bz2
	doc? ( mirror://gnu/non-gnu/cvs/source/feature/${PV}/cederqvist-${PV}.html.tar.bz2
		mirror://gnu/non-gnu/cvs/source/feature/${PV}/cederqvist-${PV}.pdf
		mirror://gnu/non-gnu/cvs/source/feature/${PV}/cederqvist-${PV}.ps )"

LICENSE="GPL-2 LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-solaris"

IUSE="crypt doc kerberos nls pam selinux server"
RESTRICT="test"

DEPEND="
	>=sys-libs/zlib-1.1.4
	kerberos? ( virtual/krb5 )
	pam? ( sys-libs/pam )
	server? ( virtual/libcrypt:= )
"
RDEPEND="
	${DEPEND}
	selinux? ( sec-policy/selinux-cvs )
"

src_unpack() {
	unpack ${P}.tar.bz2
	use doc && unpack cederqvist-${PV}.html.tar.bz2
}

PATCHES=(
	"${FILESDIR}"/${P}-cvsbug-tmpfix.patch
	"${FILESDIR}"/${P}-openat.patch
	"${FILESDIR}"/${P}-block-requests.patch
	"${FILESDIR}"/${P}-cvs-gnulib-vasnprintf.patch
	"${FILESDIR}"/${P}-install-sh.patch
	"${FILESDIR}"/${P}-hash-nameclash.patch # for AIX
	"${FILESDIR}"/${P}-getdelim.patch # 314791
	"${FILESDIR}"/${PN}-1.12.12-rcs2log-coreutils.patch # 144114
	"${FILESDIR}"/${P}-mktime-x32.patch # 395641
	"${FILESDIR}"/${P}-fix-massive-leak.patch
	"${FILESDIR}"/${P}-mktime-configure-m4.patch #220040 #570208
	"${FILESDIR}"/${P}-CVE-2012-0804.patch
	"${FILESDIR}"/${P}-format-security.patch
	"${FILESDIR}"/${P}-musl.patch
	"${FILESDIR}"/${P}-CVE-2017-12836-commandinjection.patch
	"${FILESDIR}"/0001-gettext-autoreconf.patch
	"${FILESDIR}"/0001-fix-quoting-around-potentially-empty-shell-var.patch
	"${FILESDIR}"/c99-roundup.patch
	)
DOCS=( BUGS ChangeLog{,.zoo} DEVEL-CVS FAQ HACKING MINOR-BUGS NEWS \
	PROJECTS README TESTS TODO )

src_prepare() {
	export CONFIG_SHELL=${BASH}  # configure fails without
	default
	eautoreconf
	sed -i "/^AR/s:ar:$(tc-getAR):" diff/Makefile.in lib/Makefile.in || die
}

src_configure() {
	if tc-is-cross-compiler ; then
		# Sane defaults when cross-compiling (as these tests want to
		# try and execute code).
		export cvs_cv_func_printf_ptr="yes"
	fi
	econf \
		--with-external-zlib \
		--with-tmpdir="${EPREFIX}"/tmp \
		$(use_enable crypt encryption) \
		$(use_with kerberos gssapi) \
		$(use_enable nls) \
		$(use_enable pam) \
		$(use_enable server)
}

src_install() {
	# Not installed into emacs site-lisp because it clobbers the normal C
	# indentations.
	DOCS+=( cvs-format.el )

	if use doc; then
		DOCS+=( "${DISTDIR}"/cederqvist-${PV}.{pdf,ps} )
		HTML_DOCS=( ../cederqvist-${PV}.html/. )
	fi

	default

	use doc && dosym cvs.html /usr/share/doc/${PF}/html/index.html

	if use server; then
		newdoc "${FILESDIR}"/cvs-1.12.12-cvs-custom.c cvs-custom.c
		insinto /etc/xinetd.d
		newins "${FILESDIR}"/cvspserver.xinetd.d cvspserver
		newenvd "${FILESDIR}"/01-cvs-env.d 01cvs
	fi

	if use pam; then
		newpamd "${FILESDIR}"/cvs.pam-include-1.12.12 cvs
	fi
}
