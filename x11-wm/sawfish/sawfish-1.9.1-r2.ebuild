# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/sawfish/sawfish-1.9.1-r2.ebuild,v 1.8 2015/05/14 07:44:38 mr_bones_ Exp $

EAPI=5
inherit eutils elisp-common

DESCRIPTION="Extensible window manager using a Lisp-based scripting language"
HOMEPAGE="http://sawfish.wikia.com/"
SRC_URI="http://download.tuxfamily.org/sawfish/${P}.tar.xz"

LICENSE="GPL-2 Artistic-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ~ppc64 ~sh sparc x86 ~x86-fbsd"
IUSE="emacs nls xinerama"

RDEPEND="emacs? ( virtual/emacs !app-emacs/sawfish )
	>=dev-libs/librep-0.92.1
	>=x11-libs/rep-gtk-0.90.7
	x11-libs/pangox-compat
	>=x11-libs/gtk+-2.24.0:2
	x11-libs/libXtst
	nls? ( sys-devel/gettext )
	xinerama? ( x11-libs/libXinerama )"
DEPEND="${RDEPEND}
	app-arch/xz-utils
	virtual/pkgconfig"

src_prepare() {
	# Fix firefox resizing problems, bug #462016
	epatch "${FILESDIR}/${P}-firefox.patch"
}

src_configure() {
	set -- \
		$(use_with xinerama) \
		--with-gdk-pixbuf \
		--disable-static

	if ! use nls; then
		# Use a space because configure script reads --enable-linguas="" as
		# "install everything"
		# Don't use --disable-linguas, because that means --enable-linguas="no",
		# which means "install Norwegian translations"
		set -- "$@" --enable-linguas=" "
	elif [[ "${LINGUAS+set}" == "set" ]]; then
		strip-linguas -i po
		set -- "$@" --enable-linguas=" ${LINGUAS} "
	else
		set -- "$@" --enable-linguas=""
	fi

	econf "$@"
}

src_compile() {
	emake
	use emacs && elisp-compile sawfish.el
}

src_install() {
	emake DESTDIR="${D}" install
	prune_libtool_files --modules
	dodoc AUTHORS ChangeLog DOC FAQ NEWS OPTIONS README README.IMPORTANT TODO

	if use emacs; then
		elisp-install ${PN} sawfish.{el,elc}
		elisp-site-file-install "${FILESDIR}"/50${PN}-gentoo.el
	fi
}

pkg_postinst() {
	use emacs && elisp-site-regen
}

pkg_postrm() {
	use emacs && elisp-site-regen
}
