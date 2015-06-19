# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/rex/rex-1.0.0.ebuild,v 1.1 2015/03/09 03:02:07 patrick Exp $

EAPI=5

MODULE_AUTHOR=JFRIED
MODULE_VERSION=0.53.1
MODULE_A=Rex-${PV}.tar.gz

inherit perl-module

DESCRIPTION="(R)?ex is a small script to ease the execution of remote commands"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="dev-perl/Net-SSH2"
DEPEND="${RDEPEND}
	dev-perl/JSON-XS
	dev-perl/XML-Simple
	dev-perl/Digest-SHA1
	dev-perl/Digest-HMAC
	dev-perl/Expect
	dev-perl/DBI
	dev-perl/yaml
	dev-perl/libwww-perl
	dev-perl/String-Escape
	dev-perl/List-MoreUtils
	dev-perl/Parallel-ForkManager
	dev-perl/Text-Glob"

SRC_TEST="do"

S="${WORKDIR}/Rex-${PV}"
