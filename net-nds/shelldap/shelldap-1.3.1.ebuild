# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils perl-app

DESCRIPTION="A handy shell-like interface for browsing LDAP servers and editing their content"
HOMEPAGE="http://projects.martini.nu/shelldap/"
SRC_URI="http://code.martini.nu/shelldap/archive/v${PV}.tar.bz2 -> ${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND=""
RDEPEND="dev-perl/Algorithm-Diff
	dev-perl/perl-ldap
	dev-perl/TermReadKey
	dev-perl/Term-ReadLine-Gnu
	dev-perl/Term-Shell
	dev-perl/YAML-Syck
	virtual/perl-Digest-MD5"

S="${WORKDIR}/${PN}-v${PV}"

src_prepare() {
	epatch_user
}

src_configure() { :; }

src_compile() {
	pod2man --name "${PN}" < "${PN}" > "${PN}.1" || die 'creating manpage failed'
}

src_install() {
	doman "${PN}.1"
	dobin "${PN}"
}
