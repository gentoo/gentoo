# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/pam/pam-0.ebuild,v 1.3 2014/01/18 05:16:03 vapier Exp $

EAPI=3

DESCRIPTION="Virtual for PAM (Pluggable Authentication Modules)"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~ia64-linux ~x86-linux"
IUSE=""

DEPEND=""
RDEPEND="|| ( >=sys-libs/pam-0.78
		sys-auth/openpam )"
