# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-Mbox-MessageParser/Mail-Mbox-MessageParser-1.500.200-r1.ebuild,v 1.2 2013/12/06 14:29:32 zlogene Exp $

EAPI=5

MODULE_AUTHOR=DCOPPIT
MODULE_VERSION=1.5002
inherit perl-module

DESCRIPTION="Manipulation of electronic mail addresses"
HOMEPAGE="http://sourceforge.net/projects/m-m-msgparser/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

DEPEND="dev-perl/Text-Diff
	dev-perl/FileHandle-Unget"
RDEPEND="${DEPEND}"

SRC_TEST=do

PATCHES=( "${FILESDIR}"/${PV}-warning.patch )
