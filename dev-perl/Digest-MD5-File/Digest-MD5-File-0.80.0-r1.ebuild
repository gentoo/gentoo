# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Digest-MD5-File/Digest-MD5-File-0.80.0-r1.ebuild,v 1.1 2014/08/26 18:57:39 axs Exp $

EAPI=5

MODULE_AUTHOR=DMUEY
MODULE_VERSION=0.08
inherit perl-module

DESCRIPTION="Perl extension for getting MD5 sums for files and urls"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/libwww-perl"
DEPEND="${RDEPEND}"

SRC_TEST=do
