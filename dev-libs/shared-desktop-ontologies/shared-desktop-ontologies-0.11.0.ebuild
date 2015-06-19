# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/shared-desktop-ontologies/shared-desktop-ontologies-0.11.0.ebuild,v 1.5 2013/08/02 14:33:14 ago Exp $

EAPI=5

if [[ ${PV} == *9999 ]]; then
	SCM_ECLASS="git-2"
fi
EGIT_REPO_URI="git://oscaf.git.sourceforge.net/gitroot/oscaf/shared-desktop-ontologies"
inherit cmake-utils ${SCM_ECLASS}
unset SCM_ECLASS

DESCRIPTION="Shared OSCAF desktop ontologies"
HOMEPAGE="http://sourceforge.net/projects/oscaf"
if [[ ${PV} != *9999 ]]; then
	SRC_URI="mirror://sourceforge/oscaf/${PN}/${P}.tar.bz2"
	KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux"
fi

LICENSE="|| ( BSD CC-BY-SA-3.0 )"
SLOT="0"
IUSE=""

DOCS=(AUTHORS ChangeLog README)
