# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Mail-Builder/Mail-Builder-2.80.0-r1.ebuild,v 1.1 2014/08/26 19:06:49 axs Exp $

EAPI=5

MODULE_AUTHOR=MAROS
MODULE_VERSION=2.08
inherit perl-module

DESCRIPTION="Easily create plaintext/html e-mail messages with attachments and inline images"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="examples test"

SRC_TEST="do"

RDEPEND="
	dev-perl/Class-Load
	dev-perl/Email-Address
	dev-perl/Email-Date-Format
	>=dev-perl/Email-MessageID-1.40.1
	dev-perl/Email-Valid
	dev-perl/MIME-tools
	dev-perl/HTML-Tree
	dev-perl/MIME-Types
	dev-perl/Moose
	dev-perl/Path-Class
	dev-perl/Text-Table
	dev-perl/namespace-autoclean
	"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Most
		dev-perl/Test-NoWarnings
	)"

#PATCHES=("${FILESDIR}/${PV}-escape-at-for-perl-5.8.patch")
src_install() {
	perl-module_src_install

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins example/*.pl
	fi
}
