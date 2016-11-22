# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

OASIS_BUILD_DOCS=1

inherit oasis

DESCRIPTION="A cross-platform library for manipulating the terminal"
HOMEPAGE="https://github.com/diml/lambda-term"
SRC_URI="https://github.com/diml/lambda-term/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND="
	>=dev-ml/lwt-2.4.0:=[react]
	>=dev-ml/zed-1.2:=
	>=dev-ml/camomile-0.8:=
	>=dev-ml/react-1.2:=
"
RDEPEND="${DEPEND}"

DOCS=( "CHANGES.md" "README.md" )
