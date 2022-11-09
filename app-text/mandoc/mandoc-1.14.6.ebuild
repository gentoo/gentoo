# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Suite of tools compiling mdoc and man"
HOMEPAGE="https://mdocml.bsd.lv/"
SRC_URI="https://mdocml.bsd.lv/snapshots/${P}.tar.gz"

LICENSE="ISC"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ~ia64 ~loong ~ppc ppc64 ~riscv ~s390 ~sparc x86"
IUSE="cgi system-man"

RDEPEND="sys-libs/zlib
	system-man? ( !sys-apps/man-db )
"
DEPEND="${RDEPEND}
	cgi? ( sys-libs/zlib[static-libs] )
"
BDEPEND="
	cgi? ( app-text/highlight )
"

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

	# The db-install change is to support parallel installs.
	sed -i \
		-e '/ar rs/s:ar:$(AR):' \
		-e '/^db-install:/s:$: base-install:' \
		Makefile || die

	# make-4.3 doesn't like the CC line (bug #706024)
	# and "echo -n" is not portable
	sed \
		-e "s@^\(CC=\).*\$@\1\"$(tc-getCC)\"@" \
		-e 's@echo -n@printf@g' \
		-i configure || die

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
	if use cgi; then
		cp cgi.h{.example,} || die
	fi
	if [[ -n "${MANDOC_CGI_H}" ]]; then
		cp "${MANDOC_CGI_H}" cgi.h || die
	fi

	# ./configure does not propagate all configure.local
	# settings to Makefile.local settings.
	tc-export AR
}

src_compile() {
	default
	use cgi && emake man.cgi
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
