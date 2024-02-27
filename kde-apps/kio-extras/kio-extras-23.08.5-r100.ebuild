# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Shim kio-extras to divert slot 5 users to kio-extras-kf5"
HOMEPAGE="https://invent.kde.org/network/kio-extras/-/tree/kf5"

LICENSE="metapackage"
SLOT="5"
KEYWORDS="~amd64"

RDEPEND="kde-apps/kio-extras-kf5:5"
