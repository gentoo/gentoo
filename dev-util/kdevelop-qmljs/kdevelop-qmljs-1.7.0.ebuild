# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-util/kdevelop-qmljs/kdevelop-qmljs-1.7.0.ebuild,v 1.2 2015/07/29 21:11:42 johu Exp $

EAPI=5

KDEBASE="kdevelop"
KMNAME="kdev-qmljs"
KDE_LINGUAS="bs ca ca@valencia da de el en_GB es et fi fr gl it kk nb nds nl pl
pt pt_BR ru sl sv uk zh_CN zh_TW"
MY_P="${KMNAME}-${PV}"

inherit kde4-base

DESCRIPTION="QML and javascript plugin for KDevelop 4"
LICENSE="GPL-2 LGPL-2"
IUSE="debug"
SRC_URI="mirror://kde/stable/kdevelop/${KMNAME}/${PV}/src/${MY_P}.tar.xz"
KEYWORDS="~amd64 ~x86"

S=${WORKDIR}/${MY_P}

DEPEND="
	>=dev-util/kdevplatform-${PV}:4
"
RDEPEND="${DEPEND}
	dev-util/kdevelop:4
"
