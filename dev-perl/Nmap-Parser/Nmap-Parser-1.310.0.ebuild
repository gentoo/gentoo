# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=APERSAUD
MODULE_VERSION=1.31
inherit perl-module

DESCRIPTION="Nmap::Parser - parse nmap scan data with perl"
HOMEPAGE="https://nmapparser.wordpress.com/ ${HOMEPAGE}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="virtual/perl-Storable
	>=dev-perl/XML-Twig-3.16"
DEPEND="${RDEPEND}"

SRC_TEST="do"
