# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

OASIS_BUILD_DOCS=1

LWT_VER=3.0.0

inherit oasis

DESCRIPTION="GLib integration for Lwt"
SRC_URI="https://github.com/ocsigen/lwt/releases/download/${LWT_VER}/${P}.tar.gz"
HOMEPAGE="http://ocsigen.org/lwt"

IUSE=""

DEPEND="
	>=dev-ml/lwt-${LWT_VER}:=
	>=dev-ml/react-1.2:=
"

RDEPEND="${DEPEND}"

SLOT="0/${PV}"
LICENSE="LGPL-2.1-with-linking-exception"
KEYWORDS="~amd64 ~arm ~ppc"
