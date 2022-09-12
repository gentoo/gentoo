# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LDS
DIST_VERSION=1.28
inherit perl-module

DESCRIPTION="Interface to Amazon EC2, VPC, ELB, Autoscaling, and Relational DB services"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	>=dev-perl/AnyEvent-7.40.0
	>=dev-perl/AnyEvent-CacheDNS-0.80.0
	>=dev-perl/AnyEvent-HTTP-2.150.0
	>=virtual/perl-Digest-SHA-5.470.0
	>=virtual/perl-File-Path-2.80.0
	dev-perl/JSON
	>=dev-perl/libwww-perl-5.835.0
	>=virtual/perl-MIME-Base64-3.80.0
	>=dev-perl/String-Approx-3.260.0
	>=dev-perl/URI-1.690.0
	>=dev-perl/XML-Simple-2.180.0
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
"
