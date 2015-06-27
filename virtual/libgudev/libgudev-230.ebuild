# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/libgudev/libgudev-230.ebuild,v 1.1 2015/06/27 17:34:13 floppym Exp $

EAPI=5
inherit multilib-build

DESCRIPTION="Virtual for libgudev providers"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0/0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86"
IUSE="introspection static-libs"

DEPEND=""
RDEPEND="dev-libs/libgudev:0/0[${MULTILIB_USEDEP},introspection?,static-libs?]"
