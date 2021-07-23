# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BOUMENOT
DIST_VERSION=0.62
inherit perl-module

DESCRIPTION="Framework for accessing amazon.com via SOAP and XML/HTTP"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/libwww-perl
	dev-perl/HTTP-Message
	>=dev-perl/XML-Simple-2.80.0
	>=virtual/perl-Time-HiRes-1.0.0
	>=dev-perl/Log-Log4perl-0.300.0
	virtual/perl-Digest-SHA
	dev-perl/URI
"
BDEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-0.62-no-dot-inc.patch"
)
