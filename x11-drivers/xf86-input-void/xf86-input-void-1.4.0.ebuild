# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-drivers/xf86-input-void/xf86-input-void-1.4.0.ebuild,v 1.12 2013/07/04 03:03:06 heroxbd Exp $

EAPI=4
inherit xorg-2

DESCRIPTION="null input driver"

KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND=">=x11-base/xorg-server-1.9.99.1"
DEPEND="${RDEPEND}"
