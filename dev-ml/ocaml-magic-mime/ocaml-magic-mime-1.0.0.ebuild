# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit oasis

DESCRIPTION="Convert file extensions to MIME types"
HOMEPAGE="https://github.com/mirage/ocaml-magic-mime"
SRC_URI="https://github.com/mirage/ocaml-magic-mime/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="ISC"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}"
