# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

HORDE_MAJ="-h3"
inherit horde

DESCRIPTION="Chora is the Horde CVS viewer"

KEYWORDS="alpha amd64 hppa ppc sparc x86"
IUSE=""

DEPEND=""
RDEPEND="|| ( >=www-apps/horde-3 >=www-apps/horde-groupware-1 >=www-apps/horde-webmail-1 )
	>=dev-vcs/rcs-5.7-r1
	>=dev-vcs/cvs-1.11.2"
