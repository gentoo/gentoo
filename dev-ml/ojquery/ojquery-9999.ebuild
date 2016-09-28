# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit oasis

DESCRIPTION="jQuery Binding for Eliom."
HOMEPAGE="jQuery Binding for Eliom."

if [ "${PV#9999}" != "${PV}" ] ; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/ocsigen/ojquery"
	KEYWORDS=""
else
	SRC_URI="https://github.com/ocsigen/ojquery/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="LGPL-3"
SLOT="0/${PV}"
IUSE=""

RDEPEND="dev-ml/react:=
	dev-ml/js_of_ocaml:=
	dev-ml/lwt:="
DEPEND="${RDEPEND} dev-ml/oasis"

src_prepare() {
	oasis setup || die
}
