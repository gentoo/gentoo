# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=JRED
MODULE_VERSION=0.67
MY_PN=Gtk2-Ex-FormFactory
inherit perl-module

DESCRIPTION="Gtk2 FormFactory"
HOMEPAGE="https://www.exit1.org/Gtk2-Ex-FormFactory/ ${HOMEPAGE}"

LICENSE="|| ( LGPL-2.1 LGPL-3 )" #LGPL-2.1+
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86"
IUSE=""

RDEPEND="dev-perl/Gtk2"
DEPEND="${RDEPEND}"

SRC_TEST="do"
