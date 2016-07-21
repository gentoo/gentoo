# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils systemd

DESCRIPTION="Desktop notification and configuration for dhcpcd"
HOMEPAGE="http://roy.marples.name/projects/dhcpcd-ui/"
SRC_URI="http://roy.marples.name/downloads/${PN%-ui}/${P}.tar.bz2"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="debug gtk gtk3 qt4 libnotify"
REQUIRED_USE="?? ( gtk gtk3 qt4 )
	gtk3? ( !gtk ) gtk? ( !gtk3 )"

DEPEND="${DEPEND}
	virtual/libintl
	libnotify? (
		gtk?  ( x11-libs/libnotify )
		gtk3? ( x11-libs/libnotify )
		qt4?  ( kde-base/kdelibs )
	)
	gtk?  ( x11-libs/gtk+:2 )
	gtk3? ( x11-libs/gtk+:3 )
	qt4?  ( dev-qt/qtgui:4 )"

RDEPEND=">=net-misc/dhcpcd-6.4.4"

src_prepare()
{
	epatch_user
}

src_configure()
{
	local myeconfargs=(
		$(use_enable debug)
		$(usex gtk  '--with-gtk=gtk+-2.0 --with-icons' '')
		$(usex gtk3 '--with-gtk=gtk+-3.0 --with-icons' '')
		$(usex qt4 '--with-qt --with-icons' '--without-qt')
		$(use_enable libnotify notification)
		$(use gtk || use gtk3 || echo '--without-gtk')
		$(use gtk || use gtk3 || use qt4 || echo '--without-icons')
	)
	econf "${myeconfargs[@]}"
}

src_install()
{
	emake DESTDIR="${D}" INSTALL_ROOT="${D}" install

	systemd_dounit src/dhcpcd-online/dhcpcd-wait-online.service
}
