# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

inherit autotools autotools-utils bash-completion-r1 eutils

DESCRIPTION="Archlinux's binary package manager"
HOMEPAGE="http://archlinux.org/pacman/"
SRC_URI="ftp://ftp.archlinux.org/other/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="curl debug doc gpg test"

COMMON_DEPEND="app-arch/libarchive
	dev-libs/openssl
	virtual/libiconv
	virtual/libintl
	sys-devel/gettext
	curl? ( net-misc/curl )
	gpg? ( app-crypt/gpgme )"
RDEPEND="${COMMON_DEPEND}
	app-arch/xz-utils"
# autoconf macros from gpgme requied unconditionally
DEPEND="${COMMON_DEPEND}
	app-crypt/gpgme
	doc? ( app-doc/doxygen
		app-text/asciidoc )
	test? ( dev-lang/python )"

RESTRICT="test"

src_prepare() {
	# Adds AM_GPGME_PATH call which requires app-crypt/gpgme to be
	# DEPENDed on unconditionally:
	epatch "${FILESDIR}"/${PN}-4.0.0-gpgme.patch

	# Remove a line that adds -Werror in ./configure when --enable-debug
	# is passed:
	sed -i -e '/-Werror/d' configure.ac || die "-Werror"

	# autopoint is unwilling to replace m4/gettext.m4 with the correct
	# version even though it'll gladly replace */po/Makefile.in.in,
	# creating an inconsistency between gettext m4 macros and
	# Makefile.in.in. Also, AM_MKINSTALLDIRS apparently doesn't exist
	# anymore, so we need newer gettext macros. #420469
	rm m4/gettext.m4 || die
	sed -i -e '/AM_GNU_GETTEXT_VERSION/s/0\.13\.1/0.18.1/' configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		--localstatedir=/var
		--disable-git-version
		--with-openssl
		# Help protect user from shooting his/her Gentoo installation in
		# its foot.
		--with-root-dir="${EPREFIX}"/var/chroot/archlinux
		$(use_enable debug)
		$(use_enable doc)
		$(use_enable doc doxygen)
		$(use_with curl libcurl)
		$(use_with gpg gpgme)
	)
	autotools-utils_src_configure
}

src_install() {
	autotools-utils_src_install

	dodir /etc/pacman.d
	newbashcomp "${AUTOTOOLS_BUILD_DIR}"/contrib/bash_completion pacman
}

pkg_postinst() {
	einfo "Please see http://ohnopub.net/~ohnobinki/gentoo/arch/ for information"
	einfo "about setting up an archlinux chroot."
}
