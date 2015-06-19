# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/UNIVERSAL-moniker/UNIVERSAL-moniker-0.80.0-r1.ebuild,v 1.1 2014/08/22 18:27:43 axs Exp $

EAPI=5

MODULE_AUTHOR=KASEI
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="adds a moniker to every class or module"

SLOT="0"
KEYWORDS="amd64 ~ppc ppc64 x86 ~x86-solaris"
IUSE="test"

RDEPEND=""
DEPEND="${RDEPEND}
	test? ( dev-perl/Lingua-EN-Inflect )"

SRC_TEST="do"
