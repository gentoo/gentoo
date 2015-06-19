# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/HTML-FillInForm/HTML-FillInForm-2.200.0-r1.ebuild,v 1.1 2014/08/23 02:02:01 axs Exp $

EAPI=5

MODULE_AUTHOR=MARKSTOS
MODULE_VERSION=2.20
inherit perl-module

DESCRIPTION="Populates HTML Forms with data"

SLOT="0"
KEYWORDS="amd64 ~arm ~ppc x86 ~x86-fbsd"
IUSE=""

RDEPEND="dev-perl/HTML-Parser"
DEPEND="${RDEPEND}"

SRC_TEST="do"
