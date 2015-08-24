# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=3

inherit eutils autotools

DESCRIPTION="Gnulib is a library of common routines intended to be shared at the source level"
HOMEPAGE="https://www.gnu.org/software/gnulib"

# This tar.gz is created on-the-fly when downloaded from
# http://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=snapshot;h=${GNULIB_COMMIT_GITID};sf=tgz
# So to have persistent checksums, we need to download once and cache it.
#
# To get a new version, download a "snapshot" from
# http://git.savannah.gnu.org/gitweb/?p=gnulib.git
# take the commit-id as GNULIB_COMMIT_GITID
# and the committer's timestamp (not the author's one), year to second, UTC
# as the ebuild version.
#
# To see what the last commit message for the current version was, use
# http://git.savannah.gnu.org/gitweb/?p=gnulib.git;a=commit;h=${GNULIB_COMMIT_GITID}
#
GNULIB_COMMIT_GITID=8d2524ce78ca107074727cbd8780c26a203a107c
SRC_URI="https://dev.gentoo.org/~drizzt/distfiles/${PN}-${GNULIB_COMMIT_GITID}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~ppc-aix ~x86-fbsd ~x64-freebsd ~x86-freebsd ~hppa-hpux ~ia64-hpux ~x86-interix ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

DEPEND=""
RDEPEND=""

S="${WORKDIR}"/${PN}
MY_S="${WORKDIR}"/${P}

src_prepare() {
	local requested_gnulib_modules

	case ${CHOST} in
		*-freebsd*)
			requested_gnulib_modules="mathl strndup"
			;;
		*-solaris2.8|*-solaris2.9)
			# Don't remove dirfd!
			requested_gnulib_modules="alphasort dirfd getopt scandir setenv strcasestr stdint strndup xvasprintf"
			;;
		*-solaris2.10|*-solaris2.11)
			requested_gnulib_modules="dirfd getopt strcasestr strndup xvasprintf"
			;;
		*-aix*)
			requested_gnulib_modules="alphasort dirfd getopt scandir strcasestr strndup xvasprintf"
			;;
		*-hpux*)
			requested_gnulib_modules="atoll dirfd getopt setenv strcasestr strndup xvasprintf"
			;;
		*-interix*)
			requested_gnulib_modules="atoll getopt scandir setenv strcasestr strndup xvasprintf"
			;;
		*-irix*)
			requested_gnulib_modules="getopt strcasestr strndup xvasprintf"
			;;
	esac

	epatch "${FILESDIR}"/${PN}-2008.07.23-rpl_getopt.patch
	epatch "${FILESDIR}"/${P}-scandir.patch

	# Solaris 9 ksh makes gnulib-tool to coredump
	sed -i "1s:/bin/sh:${EPREFIX}/bin/sh:" gnulib-tool || die "sed failed"

	# Remove the broken pxref
	sed -i '$d' doc/ld-version-script.texi || die "cannot fix ld-version-script.texi"

	[[ -z "$requested_gnulib_modules" ]] && return

	"${S}"/gnulib-tool --create-testdir --dir="${MY_S}" \
	${requested_gnulib_modules} || die

	cd "${MY_S}" || die

	# define both libgnu.a and the headers as to-be-installed
	LANG=C \
	sed -e '
		s,noinst_HEADERS,include_HEADERS,;
		s,noinst_LIBRARIES,lib_LIBRARIES,;
		s,noinst_LTLIBRARIES,lib_LTLIBRARIES,;
		s,EXTRA_DIST =$,&\
EXTRA_HEADERS =,;
		s,BUILT_SOURCES += \([/a-zA-Z0-9_-][/a-zA-Z0-9_-]*\.h\|\$([_A-Z0-9][_A-Z0-9]*_H)\)$,&\
include_HEADERS += \1,;
	' -i gllib/Makefile.am || die "cannot fix gllib/Makefile.am"

	eautoreconf
}

src_configure() {
	cd "${MY_S}" || return
	econf --prefix="${EPREFIX}"/usr/$(get_libdir)/${PN}
}

src_compile() {
	if use doc; then
		emake -C doc info html || die "emake failed"
	fi
	cd "${MY_S}" || return
	emake || die "cannot make ${P}"
}

src_install() {
	dodoc README ChangeLog
	if use doc; then
		dohtml doc/gnulib.html
		doinfo doc/gnulib.info
	fi

	insinto /usr/share/${PN}
	doins -r lib
	doins -r m4
	doins -r modules
	doins -r build-aux
	doins -r top

	# install the real script
	exeinto /usr/share/${PN}
	doexe gnulib-tool

	# create and install the wrapper
	dosym /usr/share/${PN}/gnulib-tool /usr/bin/gnulib-tool

	cd "${MY_S}" || return
	emake install DESTDIR="${D}" || die "make install failed"
}
