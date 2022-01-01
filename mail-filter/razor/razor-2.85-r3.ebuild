# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit perl-module readme.gentoo-r1

MY_PN="razor-agents"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Distributed, collaborative spam detection and filtering network"
HOMEPAGE="http://razor.sourceforge.net/"
SRC_URI="mirror://sourceforge/razor/${MY_P}.tar.bz2"

LICENSE="Artistic"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~x86-macos"

RDEPEND="
	dev-perl/URI
	dev-perl/Net-DNS
	virtual/perl-Net-Ping
	virtual/perl-Time-HiRes
	dev-perl/Digest-Nilsimsa
	|| ( virtual/perl-Digest-SHA dev-perl/Digest-SHA1 )
"
DEPEND=""

PATCHES=(
	"${FILESDIR}/${PN}-2.85-use-sha-not-sha1.patch"
	"${FILESDIR}/${PN}-2.85-cosmetic-pv-fix.patch"
	"${FILESDIR}/${PN}-2.85-makefile-quoting-fix.patch"
)

S="${WORKDIR}/${MY_P}"

SRC_TEST="do parallel"

DISABLE_AUTOFORMATTING="yes"
DOC_CONTENTS="
Run 'razor-admin -create' to create a default config file in your
home directory under /home/user/.razor. (Remember to change user to
your username from root before running razor-admin)

Razor v2 requires reporters to be registered so their reputations can
be computed over time and they can participate in the revocation
mechanism. Registration is done with razor-admin -register. It has to be
manually invoked in either of the following ways:

To register user foo with 's1kr3t' as password:

razor-admin -register -user=foo -pass=s1kr3t

To register with an email address and have the password assigned:

razor-admin -register -user=foo@bar.com

To have both (random) username and password assigned:

razor-admin -register

razor-admin -register negotiates a registration with the Nomination Server
and writes the identity information in
/home/user/.razor/identity-username, or /etc/razor/identity-username
when invoked as root.

You can edit razor-agent.conf to change the defaults. Config options
and their values are defined in the razor-agent.conf(5) manpage.

The next step is to integrate razor-check, razor-report and
razor-revoke in your mail system. If you are running Razor v1, the
change will be transparent, new versions of razor agents will overwrite
the old ones. You would still need to plugin razor-revoke in your MUA,
since it's a new addition in Razor v2. If you are not running Razor v1,
refer to manpages of razor-check(1), razor-report(1), and
razor-revoke(1) for integration instructions.
"

src_compile() {
	emake -j1
}

src_install() {
	mydoc="docs/*" perl-module_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
