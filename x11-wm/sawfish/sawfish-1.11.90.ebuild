# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit eutils elisp-common

MY_P="${P/-/_}"
DESCRIPTION="Extensible window manager using a Lisp-based scripting language"
HOMEPAGE="http://sawfish.wikia.com/"
SRC_URI="http://download.tuxfamily.org/sawfish/${MY_P}.tar.xz"

LICENSE="GPL-2 Artistic-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~ppc64 ~sh ~sparc ~x86 ~x86-fbsd"
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

S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS ChangeLog CONTRIBUTING doc/AUTOSTART doc/KEYBINDINGS
	   doc/OPTIONS doc/XSettings MAINTAINERS NEWS README README.IMPORTANT
	   TODO )

src_configure() {
	# The configure script tries to use kde4-config (bug #573664) or
	# kf5-config (from kdelibs4support) to detect where it should put
	# its session files. This could probably be enabled for kde5 going
	# forward (behind USE=kde), but there's currently a bug in the
	# configure script preventing that from working nicely:
	#
	#   https://github.com/SawfishWM/sawfish/issues/22
	#
	# For now, we just disable the kde[45] session support entirely.
	set -- \
		$(use_with xinerama) \
		--with-gdk-pixbuf \
		--without-kde4session \
		--without-kde5session \
		--disable-static

	if ! use nls; then
		# Use a space because configure script reads --enable-linguas=""
		# as "install everything". Don't use --disable-linguas, because
		# that means --enable-linguas="no", which means "install
		# Norwegian translations".
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
	default
	use emacs && elisp-compile sawfish.el
}

src_install() {
	default
	prune_libtool_files --modules

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
