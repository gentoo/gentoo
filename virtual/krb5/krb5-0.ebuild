# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/krb5/krb5-0.ebuild,v 1.2 2013/06/27 20:42:55 aballier Exp $

EAPI=3

DESCRIPTION="Virtual for Kerberos V implementation"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

DEPEND=""
RDEPEND="|| ( app-crypt/mit-krb5 app-crypt/heimdal )"
