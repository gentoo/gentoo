# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

DESCRIPTION="Suite of tools compiling mdoc and man"
HOMEPAGE="https://mdocml.bsd.lv/"
SRC_URI="https://mdocml.bsd.lv/snapshots/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="cgi selinux system-man test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/zlib:=
	system-man? ( !sys-apps/man-db )
"
DEPEND="${RDEPEND}
	cgi? ( virtual/zlib:=[static-libs] )
"
BDEPEND="
	cgi? ( app-text/highlight )
	test? ( dev-lang/perl )
"
RDEPEND+=" selinux? ( sec-policy/selinux-makewhatis )"

QA_CONFIG_IMPL_DECL_SKIP=(
	# BSD, provided by compat_progname.c
	getprogname
	# BSD, not required
	pledge
	# BSD, provided by compat_recallocarray.c
	recallocarray
	# BSD, provided by compat_strtonum.c
	strtonum
	# tested by configure w/o and then w/ _GNU_SOURCE
	# avoid the warn for the first check
	strcasestr # for musl
	strptime
	wcwidth
)

PATCHES=(
	"${FILESDIR}"/${PN}-1.14.5-r1-www-install.patch
)

pkg_pretend() {
	if use system-man ; then
		# only support uncompressed and gzip
		[[ -n ${PORTAGE_COMPRESS+unset} ]] && \
		[[ "${PORTAGE_COMPRESS}" == "gzip" || "${PORTAGE_COMPRESS}" == "" ]] || \
		ewarn "only PORTAGE_COMPRESS=gzip or '' is supported, man pages will not be indexed"
	fi
}

src_prepare() {
	default

	cat <<-EOF > "configure.local"
		PREFIX="${EPREFIX}/usr"
		BINDIR="${EPREFIX}/usr/bin"
		SBINDIR="${EPREFIX}/usr/sbin"
		LIBDIR="${EPREFIX}/usr/$(get_libdir)"
		MANDIR="${EPREFIX}/usr/share/man"
		INCLUDEDIR="${EPREFIX}/usr/include/mandoc"
		EXAMPLEDIR="${EPREFIX}/usr/share/examples/mandoc"
		MANPATH_DEFAULT="${EPREFIX}/usr/man:${EPREFIX}/usr/share/man:${EPREFIX}/usr/local/man:${EPREFIX}/usr/local/share/man"

		CFLAGS="${CFLAGS} ${CPPFLAGS}"
		LDFLAGS="${LDFLAGS}"
		AR="$(tc-getAR)"
		CC="$(tc-getCC)"
		# The STATIC variable is only used by man.cgi.
		STATIC=

		# conflicts with sys-apps/groff
		BINM_SOELIM=msoelim
		MANM_ROFF=mandoc_roff
		# conflicts with sys-apps/man-pages
		MANM_MAN=mandoc_man

		# fix utf-8 locale on musl
		$(usex elibc_musl UTF8_LOCALE=C.UTF-8 '')
	EOF
	use system-man || cat <<-EOF >> "configure.local"
		BINM_MAN=mman
		BINM_APROPOS=mapropos
		BINM_WHATIS=mwhatis
		BINM_MAKEWHATIS=mmakewhatis
		MANM_MDOC=mandoc_mdoc
		MANM_EQN=mandoc_eqn
		MANM_TBL=mandoc_tbl
		MANM_MANCONF=mman.conf
	EOF
	# Assuming modern Linux + glibc/musl and not BSD.
	tc-is-cross-compiler && cat <<-EOF >> "configure.local"
		HAVE_ATTRIBUTE=1
		HAVE_CMSG=1
		HAVE_DIRENT_NAMLEN=0
		HAVE_EFTYPE=0
		HAVE_ENDIAN=1
		HAVE_ERR=1
		HAVE_FTS_COMPARE_CONST=0
		HAVE_FTS=$(usex elibc_glibc 1 0)
		HAVE_GETLINE=1
		HAVE_GETSUBOPT=1
		HAVE_ISBLANK=1
		HAVE_LESS_T=1
		HAVE_MKDTEMP=1
		HAVE_MKSTEMPS=1
		HAVE_NANOSLEEP=1
		HAVE_NTOHL=1
		HAVE_O_DIRECTORY=1
		HAVE_OHASH=0
		HAVE_PATH_MAX=1
		HAVE_PLEDGE=0
		HAVE_PROGNAME=0
		HAVE_REALLOCARRAY=1
		HAVE_RECALLOCARRAY=0
		HAVE_RECVMSG=1
		HAVE_REWB_BSD=0
		HAVE_REWB_SYSV=1
		HAVE_SANDBOX_INIT=0
		HAVE_STRCASESTR=$(usex elibc_glibc 1 0)
		HAVE_STRINGLIST=0
		HAVE_STRLCAT=$(usex elibc_glibc 1 0)
		HAVE_STRLCPY=$(usex elibc_glibc 1 0)
		HAVE_STRPTIME=1
		HAVE_STRSEP=1
		HAVE_STRTONUM=0
		HAVE_SYS_ENDIAN=0
		HAVE_VASPRINTF=1
		HAVE_WCHAR=1
		NEED_GNU_SOURCE=1
	EOF
	if use cgi; then
		cp cgi.h{.example,} || die
	fi
	if [[ -n "${MANDOC_CGI_H}" ]]; then
		cp "${MANDOC_CGI_H}" cgi.h || die
	fi
}

src_compile() {
	default
	use cgi && emake man.cgi
}

src_test() {
	emake regress
}

src_install() {
	emake DESTDIR="${D}" install
	use cgi && emake DESTDIR="${D}" cgi-install www-install

	if use system-man ; then
		exeinto /etc/cron.daily
		newexe "${FILESDIR}"/mandoc.cron-r0 mandoc
	fi
}

pkg_postinst() {
	if use system-man ; then
		elog "Generating mandoc database"
		makewhatis || die
	fi
}
