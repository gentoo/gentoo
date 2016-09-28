# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit oasis

DESCRIPTION="jQuery Binding for Eliom."
HOMEPAGE="jQuery Binding for Eliom."
SRC_URI="https://github.com/ocsigen/ojquery/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0/${PV}"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="dev-ml/react:=
	dev-ml/js_of_ocaml:=
	dev-ml/lwt:="
DEPEND="${RDEPEND} dev-ml/oasis"

src_prepare() {
	oasis setup || die
}
