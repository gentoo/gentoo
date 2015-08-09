# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils user

DESCRIPTION="Jabber servers and transports layout package"
SRC_URI=""
HOMEPAGE="http://www.gentoo.org/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ~ia64 ppc sparc x86 ~x86-fbsd"
IUSE=""

DEPEND=""

S="${WORKDIR}"

#Info for people working in jabber related packages

#/etc/jabber/ for configuration files
#/var/run/jabber/ for the pid files
#/var/spool/jabber/ for the flat files databases (actually there must be a ewarn
#at end of ebuild telling user to creat /var/spool/jabber/JID, as some transports fail to start if
#the directory is not there, even if they have permissions to creat it)
#/var/log/jabber/ for the log files

#for the python based transports with no install script:
#they must inherit python and be installed in:
#$(python_get_sitedir)/$package-name

#the user should be the one created here username=group=jabber

src_install() {
	keepdir /etc/jabber
	keepdir /var/run/jabber
	keepdir /var/spool/jabber
	keepdir /var/log/jabber
}

pkg_postinst() {
	# Users should not be created in src_install see bug #124680
	# Add our default jabber group and user
	enewgroup jabber
	enewuser jabber -1 -1 -1 jabber
	# We can't use fowners & fperms convenience wrappers as we are outside the sandbox
	chown jabber:jabber /etc/jabber /var/log/jabber /var/spool/jabber /var/run/jabber
	chmod 770 /etc/jabber /var/log/jabber /var/spool/jabber /var/run/jabber
}
