# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Authen-Htpasswd/Authen-Htpasswd-0.171.0-r1.ebuild,v 1.1 2014/08/23 01:57:52 axs Exp $

EAPI=5

MODULE_AUTHOR=MSTROUT
MODULE_VERSION=0.171
inherit perl-module

DESCRIPTION="interface to read and modify Apache .htpasswd files"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND="dev-perl/Class-Accessor
	dev-perl/IO-LockedFile
	dev-perl/Crypt-PasswdMD5
	dev-perl/Digest-SHA1"
# pod tests need TEST_POD anyway
RDEPEND="${DEPEND}"

SRC_TEST=do
