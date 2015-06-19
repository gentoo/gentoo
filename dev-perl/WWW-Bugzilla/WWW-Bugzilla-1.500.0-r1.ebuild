# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/WWW-Bugzilla/WWW-Bugzilla-1.500.0-r1.ebuild,v 1.1 2014/08/24 02:14:57 axs Exp $

EAPI=5

MODULE_AUTHOR=BMC
MODULE_VERSION=1.5
inherit perl-module

DESCRIPTION="WWW::Bugzilla - automate interaction with bugzilla"

SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

RDEPEND="dev-perl/WWW-Mechanize
	>=dev-perl/Params-Validate-0.88
	>=dev-perl/Crypt-SSLeay-0.57
	dev-perl/Class-MethodMaker"
DEPEND="${RDEPEND}"

src_prepare() {
	perl-module_src_prepare
	mkdir "${S}"/lib
	cp -r "${S}"/{WWW,lib}
}
