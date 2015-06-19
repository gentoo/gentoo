# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/subtle/subtle-0.11.3224.ebuild,v 1.1 2012/06/20 19:33:35 radhermit Exp $

EAPI="4"
USE_RUBY="ruby19"

inherit ruby-ng toolchain-funcs

GR="xi"

DESCRIPTION="A manual tiling window manager"
HOMEPAGE="http://subforge.org/projects/subtle/wiki"
SRC_URI="http://subforge.org/attachments/download/81/${P}-${GR}.tbz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug doc +xft xinerama xpm +xrandr +xtest"

RDEPEND="x11-libs/libX11
	xft? ( x11-libs/libXft )
	xinerama? ( x11-libs/libXinerama )
	xpm? ( x11-libs/libXpm )
	xtest? ( x11-libs/libXtst )
	xrandr? ( x11-libs/libXrandr )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

ruby_add_rdepend "dev-ruby/archive-tar-minitar"
ruby_add_bdepend "dev-ruby/rake"

RUBY_S="${P}-${GR}"

RUBY_PATCHES=( "${FILESDIR}"/${P}-flags.patch )

each_ruby_configure() {
	local myconf
	use debug && myconf+=" debug=yes" || myconf+=" debug=no"
	use xft && myconf+=" xft=yes" || myconf+=" xft=no"
	use xinerama && myconf+=" xinerama=yes" || myconf+=" xinerama=no"
	use xpm && myconf+=" xpm=yes" || myconf+=" xpm=no"
	use xtest && myconf+=" xtest=yes" || myconf+=" xtest=no"
	use xrandr && myconf+=" xrandr=yes" || myconf+=" xrandr=no"

	${RUBY} -S rake -v CC="$(tc-getCC)" destdir="${D}" ${myconf} config || die
}

each_ruby_compile() {
	${RUBY} -S rake -v build || die
}

all_ruby_compile() {
	use doc && { rake rdoc || die ; }
}

each_ruby_install() {
	${RUBY} -S rake -v install || die
}

all_ruby_install() {
	dodir /etc/X11/Sessions
	cat <<-EOF > "${D}/etc/X11/Sessions/${PN}"
		#!/bin/sh
		exec /usr/bin/subtle
	EOF
	fperms a+x /etc/X11/Sessions/${PN}

	insinto /usr/share/xsessions
	doins data/${PN}.desktop

	dodoc AUTHORS NEWS

	use doc && dohtml -r html/*
}

pkg_postinst() {
	elog "Note that surserver will currently not work since dev-ruby/datamapper"
	elog "is not in the tree."
}
