# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DBIx-Safe/DBIx-Safe-1.2.5.ebuild,v 1.4 2014/10/13 21:58:47 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=TURNSTEP
MODULE_VERSION=1.2.5
inherit perl-module eutils

DESCRIPTION="Safer access to your database through a DBI database handle"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
LICENSE="BSD-2"

RDEPEND="dev-perl/DBI
	dev-perl/DBD-Pg"
DEPEND="${RDEPEND}"
