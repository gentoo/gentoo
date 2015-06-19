# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/autodia/autodia-2.140.0-r1.ebuild,v 1.1 2014/10/26 15:39:40 dilfridge Exp $

EAPI=5

MY_PN=Autodia
MODULE_VERSION=2.14
MODULE_AUTHOR=TEEJAY
GENTOO_DEPEND_ON_PERL_SUBSLOT=yes
inherit perl-app multilib

DESCRIPTION="Parses source code, XML or data and produces an XML document in Dia format"
HOMEPAGE="http://www.aarontrevena.co.uk/opensource/autodia/ ${HOMEPAGE}"
SRC_URI+=" http://dev.gentoo.org/~tove/distfiles/${CATEGORY}/${MY_PN}-2.14-dbi.patch.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="graphviz test"

RDEPEND="
	dev-perl/Template-Toolkit
	dev-perl/XML-Simple
	graphviz? (
		dev-perl/GraphViz
	)
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
	)
"

SRC_TEST=do
PATCHES=( "${WORKDIR}"/${MY_PN}-2.14-dbi.patch )
mydoc="DEVELOP"
