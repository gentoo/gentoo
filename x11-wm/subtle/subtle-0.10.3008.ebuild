# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-wm/subtle/subtle-0.10.3008.ebuild,v 1.4 2011/10/29 05:38:09 radhermit Exp $

EAPI="4"
USE_RUBY="ruby19"

inherit ruby-ng

GR="nu"

DESCRIPTION="A manual tiling window manager"
HOMEPAGE="http://subforge.org/projects/subtle/wiki"
SRC_URI="http://subforge.org/attachments/download/75/${P}-${GR}.tbz2"

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
DEPEND="${RDEPEND}"

ruby_add_rdepend "dev-ruby/archive-tar-minitar"
ruby_add_bdepend "dev-ruby/rake"

RUBY_S="${P}-${GR}"

each_ruby_configure() {
	local myconf
	use debug && myconf+=" debug=yes" || myconf+=" debug=no"
	use xft && myconf+=" xft=yes" || myconf+=" xft=no"
	use xinerama && myconf+=" xinerama=yes" || myconf+=" xinerama=no"
	use xpm && myconf+=" xpm=yes" || myconf+=" xpm=no"
	use xtest && myconf+=" xtest=yes" || myconf+=" xtest=no"
	use xrandr && myconf+=" xrandr=yes" || myconf+=" xrandr=no"

	${RUBY} -S rake destdir="${D}" ${myconf} config || die
}

each_ruby_compile() {
	${RUBY} -S rake build || die
}

each_ruby_install() {
	${RUBY} -S rake install || die
}

all_ruby_install() {
	dodir /etc/X11/Sessions
	cat <<-EOF > "${D}/etc/X11/Sessions/${PN}"
		#!/bin/sh
		exec /usr/bin/subtle
	EOF
	fperms a+x /etc/X11/Sessions/${PN}

	dodoc AUTHORS NEWS

	if use doc ; then
		rake rdoc || die
		dohtml -r html/*
	fi
}

pkg_postinst() {
	elog "Note that surserver will currently not work since dev-ruby/datamapper"
	elog "is not in the tree yet."
}
