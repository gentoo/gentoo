# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/freedesktop-icon-theme/freedesktop-icon-theme-0.ebuild,v 1.13 2015/06/04 19:04:26 kensington Exp $

EAPI=4

DESCRIPTION="A virtual to choose between different icon themes"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ~mips ppc ppc64 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~x86-interix ~amd64-linux ~ia64-linux ~x86-linux ~x86-solaris"
IUSE=""

RDEPEND="|| (
	x11-themes/gnome-icon-theme
	x11-themes/faenza-icon-theme
	lxde-base/lxde-icon-theme
	x11-themes/tango-icon-theme
	kde-apps/oxygen-icons
	x11-themes/mate-icon-theme
)
"
