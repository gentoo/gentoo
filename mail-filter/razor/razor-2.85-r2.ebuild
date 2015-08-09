# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit perl-module

MY_PN="razor-agents"
MY_P="${MY_PN}-${PV}"
DESCRIPTION="Vipul's Razor is a distributed, collaborative spam detection and filtering network"
HOMEPAGE="http://razor.sourceforge.net/"
SRC_URI="mirror://sourceforge/razor/${MY_P}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="alpha amd64 hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"
# This package warrants IUSE doc
IUSE=""

DEPEND=""

RDEPEND="dev-perl/Net-DNS
	virtual/perl-Net-Ping
	virtual/perl-Time-HiRes
	|| ( virtual/perl-Digest-SHA dev-perl/Digest-SHA1 )
	dev-perl/URI
	dev-perl/Digest-Nilsimsa"

PATCHES=(
	"${FILESDIR}/${PN}-2.85-use-sha-not-sha1.patch"
	"${FILESDIR}/${PN}-2.85-cosmetic-pv-fix.patch"
	)

S=${WORKDIR}/${MY_P}
# Install docs/ content
mydoc="docs/*"
SRC_TEST="do parallel"

pkg_postinst() {
	elog
	elog "Run 'razor-admin -create' to create a default config file in your"
	elog "home directory under /home/user/.razor. (Remember to change user to"
	elog "your username from root before running razor-admin)"
	elog
	elog "Razor v2 requires reporters to be registered so their reputations can"
	elog "be computed over time and they can participate in the revocation"
	elog "mechanism. Registration is done with razor-admin -register. It has to be"
	elog "manually invoked in either of the following ways:"
	elog
	elog "To register user foo with 's1kr3t' as password: "
	elog
	elog "razor-admin -register -user=foo -pass=s1kr3t"
	elog
	elog "To register with an email address and have the password assigned:"
	elog
	elog "razor-admin -register -user=foo@bar.com      "
	elog
	elog "To have both (random) username and password assgined: "
	elog
	elog "razor-admin -register "
	elog
	elog "razor-admin -register negotiates a registration with the Nomination Server"
	elog "and writes the identity information in"
	elog "/home/user/.razor/identity-username, or /etc/razor/identity-username"
	elog "when invoked as root."
	elog
	elog "You can edit razor-agent.conf to change the defaults. Config options"
	elog "and their values are defined in the razor-agent.conf(5) manpage."
	elog
	elog "The next step is to integrate razor-check, razor-report and"
	elog "razor-revoke in your mail system. If you are running Razor v1, the"
	elog "change will be transparent, new versions of razor agents will overwrite"
	elog "the old ones. You would still need to plugin razor-revoke in your MUA,"
	elog "since it's a new addition in Razor v2. If you are not running Razor v1,"
	elog "refer to manpages of razor-check(1), razor-report(1), and"
	elog "razor-revoke(1) for integration instructions."
	elog
}
