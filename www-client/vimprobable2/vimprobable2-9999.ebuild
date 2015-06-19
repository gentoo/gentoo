# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/www-client/vimprobable2/vimprobable2-9999.ebuild,v 1.4 2014/07/19 04:53:56 radhermit Exp $

EAPI=5
inherit toolchain-funcs savedconfig

if [[ ${PV} == 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://git.code.sf.net/p/vimprobable/code"
else
	SRC_URI="mirror://sourceforge/vimprobable/${PN}_${PV}.tar.bz2"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/${PN}
fi

DESCRIPTION="A minimal web browser that behaves like the Vimperator plugin for Firefox"
HOMEPAGE="http://www.vimprobable.org/"

LICENSE="MIT"
SLOT="0"

RDEPEND="net-libs/libsoup:2.4
	net-libs/webkit-gtk:2
	x11-libs/gtk+:2
	x11-libs/libX11"
DEPEND="${RDEPEND}
	dev-lang/perl
	virtual/pkgconfig"

src_prepare() {
	tc-export CC
	restore_config config.h keymap.h
}

src_install() {
	dobin ${PN}
	doman ${PN}.1 vimprobablerc.5

	save_config config.h keymap.h
}
