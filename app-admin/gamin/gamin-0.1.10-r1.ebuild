# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/gamin/gamin-0.1.10-r1.ebuild,v 1.11 2014/06/18 19:00:16 mgorny Exp $

EAPI=5

inherit multilib-build

DESCRIPTION="Meta package providing the File Alteration Monitor API & Server"
HOMEPAGE="http://www.gnome.org/~veillard/gamin/"
SRC_URI=""

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~x86-interix ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="!app-admin/fam
	>=dev-libs/libgamin-0.1.10-r4[${MULTILIB_USEDEP}]"
DEPEND=""

PDEPEND=">=app-admin/gam-server-0.1.10"
