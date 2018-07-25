# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit gkrellm-plugin

DESCRIPTION="GKrellM2 Plugin for the Dell Inspiron and Latitude notebooks"
SRC_URI="http://www.coding-zone.com/${P}.tar.gz"
HOMEPAGE="http://www.coding-zone.com/?page=i8krellm"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	app-admin/gkrellm:2[X]
	>=app-laptop/i8kutils-1.5"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-Respect-LDFLAGS.patch )
