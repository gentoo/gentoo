# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Geo-IP/Geo-IP-1.450.0.ebuild,v 1.9 2015/05/13 07:00:57 jmorgan Exp $

EAPI=5

MODULE_AUTHOR=MAXMIND
MODULE_VERSION=1.45
inherit perl-module multilib

DESCRIPTION="Look up country by IP Address"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd"
IUSE=""

DEPEND="dev-libs/geoip"
RDEPEND="${DEPEND}"

SRC_TEST=do
myconf="LIBS=-L/usr/$(get_libdir)"
