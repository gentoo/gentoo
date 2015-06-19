# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/osdt/osdt-1.1.5.ebuild,v 1.1 2013/12/16 07:21:51 patrick Exp $

DESCRIPTION="tools for Open Source software distribution"
HOMEPAGE="http://sourceforge.net/projects/osdt/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tbz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND=""
RDEPEND=">=dev-lang/perl-5
	dev-perl/XML-Simple
	sys-devel/m4"

src_compile() { :; }

src_install() {
	emake DESTDIR="${D}" PREFIX=/usr SYSCONFDIR=/etc \
	  INFODIR=/usr/share/info MANDIR=/usr/share/man install || die

	# Hack until the fix can be incorporated upstream: fix the permissions
	# on /etc/osdt/project-skeletons/opensource/
	chmod 755 "${D}"/etc/osdt/project-skeletons/opensource/
}
