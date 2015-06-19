# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-misc/realpath/realpath-1.17.ebuild,v 1.12 2013/01/01 19:16:14 armin76 Exp $

EAPI=4
inherit eutils toolchain-funcs flag-o-matic multilib prefix

DESCRIPTION="Return the canonicalized absolute pathname"
HOMEPAGE="http://packages.debian.org/unstable/utils/realpath"
SRC_URI="
	mirror://debian/pool/main/r/${PN}/${PN}_${PV}.tar.gz
	nls? ( mirror://debian/pool/main/r/${PN}/${PN}_${PV}_i386.deb )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="nls"

RDEPEND="!sys-freebsd/freebsd-bin
	nls? ( virtual/libintl )"
DEPEND="${RDEPEND}
	nls? ( sys-devel/gettext )
	x86-interix? ( dev-libs/gnulib )
	elibc_mintlib? ( virtual/libiconv )"

src_unpack() {
	unpack ${PN}_${PV}.tar.gz

	if use nls; then
		# Unpack the .deb file, in order to get the preprocessed man page
		# translations. This way we avoid a dependency on app-text/po4a.
		mkdir deb
		cd deb
		unpack ${PN}_${PV}_i386.deb
		unpack ./data.tar.gz
	fi
}

src_prepare() {
	use nls || epatch "${FILESDIR}"/${PN}-1.16-nonls.patch
	epatch "${FILESDIR}"/${PN}-1.17-build.patch
	epatch "${FILESDIR}"/${PN}-1.14-no-po4a.patch
	epatch "${FILESDIR}"/${PN}-1.15-prefix.patch
	eprefixify common.mk
}

src_compile() {
	tc-export CC
	use nls && use !elibc_glibc && append-libs -lintl
	[[ ${CHOST} == *-mint* ]] && append-libs "-liconv"
	if [[ ${CHOST} == *-irix* || ${CHOST} == *-interix[35]* ]] ; then
		append-flags -I"${EPREFIX}"/usr/$(get_libdir)/gnulib/include
		append-ldflags -L"${EPREFIX}"/usr/$(get_libdir)/gnulib/$(get_libdir)
		append-libs -lgnu
	fi

	local subdir
	for subdir in src man $(usex nls po ''); do
		emake MAKE_VERBOSE=yes VERSION="${PV}" -C ${subdir}
	done
}

src_install() {
	emake VERSION="${PV}" SUBDIRS="src man $(usex nls po '')" \
		DESTDIR="${D}" install
	newdoc debian/changelog ChangeLog.debian

	if use nls; then
		local dir
		for dir in "${WORKDIR}"/deb/usr/share/man/*; do
			[ -f "${dir}"/man1/realpath.1 ] || continue
			newman "${dir}"/man1/realpath.1 realpath.${dir##*/}.1
		done
	fi
}
