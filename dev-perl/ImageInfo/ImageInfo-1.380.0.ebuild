# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/ImageInfo/ImageInfo-1.380.0.ebuild,v 1.1 2015/07/01 12:23:29 zlogene Exp $

EAPI=5

MY_PN=Image-Info
MODULE_AUTHOR=SREZIC
MODULE_VERSION=1.38
inherit perl-module

DESCRIPTION="The Perl Image-Info Module"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86"
IUSE=""

DEPEND=">=dev-perl/IO-String-1.01
	dev-perl/XML-LibXML
	dev-perl/XML-Simple"
RDEPEND="${DEPEND}"

SRC_TEST="do"
