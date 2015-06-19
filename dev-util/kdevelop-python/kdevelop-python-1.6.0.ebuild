# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdevelop-python/kdevelop-python-1.6.0.ebuild,v 1.2 2014/03/17 09:54:03 kensington Exp $

EAPI=5

KDEBASE="kdevelop"
KMNAME="kdev-python"
KDE_LINGUAS="bs ca ca@valencia da de es fi fr gl it kk nl pt pt_BR sk sl sv uk
zh_TW"
inherit kde4-base

MY_PN="${KMNAME}"
MY_P="${MY_PN}-${PV}"

if [[ $PV != *9999* ]]; then
	SRC_URI="mirror://kde/stable/kdevelop/${KDEVELOP_VERSION}/src/${MY_P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
	S=${WORKDIR}/${MY_P}
else
	EGIT_REPO_URI="git://anongit.kde.org/kdev-python.git"
	KEYWORDS=""
fi

DESCRIPTION="Python plugin for KDevelop 4"
HOMEPAGE="http://www.kdevelop.org"

LICENSE="GPL-2"
IUSE="debug"

DEPEND="
	>=dev-util/kdevplatform-${KDEVPLATFORM_VERSION}
"
RDEPEND="
	${DEPEND}
	dev-util/kdevelop
"

RESTRICT="test"

src_compile() {
	pushd "${WORKDIR}"/${P}_build > /dev/null
	emake parser
	popd > /dev/null

	kde4-base_src_compile
}
