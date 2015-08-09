# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit games

MY_P="${P/_beta/b}"
DESCRIPTION="A small, flexible, screen-oriented MUD client (aka TinyFugue)"
HOMEPAGE="http://tinyfugue.sourceforge.net/"
SRC_URI="mirror://sourceforge/tinyfugue/${MY_P}.tar.gz
	http://homepage.mac.com/mikeride/abelinc/scripts/allrootpatch.txt ->
	tf-allrootpatch.txt
	http://homepage.mac.com/mikeride/abelinc/scripts/allsrcpatch.txt ->
	tf-allsrcpatch.txt
	doc? ( mirror://sourceforge/tinyfugue/${MY_P}-help.tar.gz )"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="+atcp debug doc +gmcp ipv6 +option102 ssl"

RDEPEND="ssl? ( dev-libs/openssl )
	dev-libs/libpcre"
DEPEND=${RDEPEND}

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch \
		"${DISTDIR}"/tf-all*patch.txt \
		"${FILESDIR}"/${P}-pcre.patch \
		"${FILESDIR}"/${P}-stdarg.patch
}

src_configure() {
	STRIP=: egamesconf \
		$(use_enable atcp) \
		$(use_enable gmcp) \
		$(use_enable option102) \
		$(use_enable ssl) \
		$(use_enable debug core) \
		$(use_enable ipv6 inet6) \
		--enable-manpage
}

src_install() {
	dogamesbin src/tf
	newman src/tf.1.nroffman tf.1
	dodoc CHANGES CREDITS README

	insinto "${GAMES_DATADIR}"/${PN}-lib
	# the application looks for this file here if /changes is called.
	# see comments on bug #23274
	doins CHANGES
	insopts -m0755
	doins tf-lib/*
	if use doc ; then
		cd ../${MY_P}-help
		dohtml -r *.html commands topics
		cd ../${MY_P}
	fi
	prepgamesdirs
}

pkg_postinst() {
	games_pkg_postinst
	use ipv6 && {
		echo
		ewarn "You have merged TinyFugue with IPv6-support."
		ewarn "Support for IPv6 is still being experimental."
		ewarn "If you experience problems with connecting to hosts,"
		ewarn "try re-merging this package with USE="-ipv6""
		echo
	}
}
