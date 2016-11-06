# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
KDE_MINIMAL=4.13.0

inherit kde4-base

DESCRIPTION="Alternative configuration module for the Baloo search framework"
HOMEPAGE="https://gitlab.com/baloo-kcmadv/baloo-kcmadv"
EGIT_REPO_URI="https://gitlab.com/${PN}/${PN}.git"
SRC_URI="https://dev.gentoo.org/~dilfridge/distfiles/${P}.tar.xz"

LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86"
SLOT="4"
IUSE=""

DEPEND="
	dev-libs/qjson
	dev-libs/xapian
	kde-frameworks/baloo:4[-minimal]
	kde-frameworks/kfilemetadata:4
"
RDEPEND="${DEPEND}"
