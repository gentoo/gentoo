# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils flag-o-matic toolchain-funcs

ECCVER="0.2.0"
ECCVER_GNUPG="1.4.9"
ECC_PATCH="${PN}-${ECCVER_GNUPG}-ecc${ECCVER}.diff"
MY_P=${P/_/}

DESCRIPTION="The GNU Privacy Guard, a GPL pgp replacement"
HOMEPAGE="http://www.gnupg.org/"
SRC_URI="mirror://gnupg/gnupg/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="bzip2 curl ldap mta nls readline selinux smartcard static usb zlib"

COMMON_DEPEND="
	ldap? ( net-nds/openldap )
	bzip2? ( app-arch/bzip2 )
	zlib? ( sys-libs/zlib )
	curl? ( net-misc/curl )
	mta? ( virtual/mta )
	readline? ( sys-libs/readline:0= )
	smartcard? ( =virtual/libusb-0* )
	usb? ( =virtual/libusb-0* )"

RDEPEND="!static? ( ${COMMON_DEPEND} )
	selinux? ( sec-policy/selinux-gpg )
	nls? ( virtual/libintl )"

DEPEND="${COMMON_DEPEND}
	dev-lang/perl
	nls? ( sys-devel/gettext )"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	# bug#469388
	sed -i -e 's/--batch --dearmor/--homedir . --batch --dearmor/' checks/Makefile.in

	# Fix PIC definitions
	sed -i -e 's:PIC:__PIC__:' mpi/i386/mpih-{add,sub}1.S intl/relocatable.c \
		|| die "sed PIC failed"
	sed -i -e 's:if PIC:ifdef __PIC__:' mpi/sparc32v8/mpih-mul{1,2}.S || \
		die "sed PIC failed"
}

src_configure() {
	# Certain sparc32 machines seem to have trouble building correctly with
	# -mcpu enabled.  While this is not a gnupg problem, it is a temporary
	# fix until the gcc problem can be tracked down.
	if [ "${ARCH}" == "sparc" ] && [ "${PROFILE_ARCH}" == "sparc" ]; then
		filter-flags -mcpu=supersparc -mcpu=v8 -mcpu=v7
	fi

	# 'USE=static' support was requested in #29299
	use static && append-ldflags -static

	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		$(use_enable ldap) \
		$(use_enable mta mailto) \
		--enable-hkp \
		--enable-finger \
		$(use_with !zlib included-zlib) \
		$(use_with curl libcurl /usr) \
		$(use_enable nls) \
		$(use_enable bzip2) \
		$(use_enable smartcard card-support) \
		$(use_enable selinux selinux-support) \
		--without-capabilities \
		$(use_with readline) \
		$(use_with usb libusb /usr) \
		--enable-static-rnd=linux \
		--libexecdir="${EPREFIX}/usr/libexec" \
		--enable-noexecstack \
		CC_FOR_BUILD=$(tc-getBUILD_CC) \
		${myconf}
}

src_install() {
	default

	# keep the documentation in /usr/share/doc/...
	rm -rf "${ED}usr/share/gnupg/FAQ" "${ED}usr/share/gnupg/faq.html" || die

	dodoc AUTHORS BUGS ChangeLog NEWS PROJECTS README THANKS \
		TODO VERSION doc/{FAQ,HACKING,DETAILS,OpenPGP}

	exeinto /usr/libexec/gnupg
	doexe tools/make-dns-cert
}

pkg_postinst() {
	ewarn "If you are using a non-Linux system, or a kernel older than 2.6.9,"
	ewarn "you MUST make the gpg binary setuid."
	echo
#	if use !bindist && use ecc; then
#		ewarn
#		ewarn "The elliptical curves patch is experimental"
#		ewarn "Further info available at http://alumnes.eps.udl.es/%7Ed4372211/index.en.html"
#	fi
	elog
	elog "See https://www.gentoo.org/doc/en/gnupg-user.xml for documentation on gnupg"
	elog
	elog "If you wish to view images emerge:"
	elog "media-gfx/xloadimage, media-gfx/xli or any other viewer"
	elog "Remember to use photo-viewer option in configuration file to activate the right viewer"
}
