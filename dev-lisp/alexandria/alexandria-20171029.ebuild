# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit common-lisp-3 eutils

DESCRIPTION="A collection of portable utilities for Common Lisp"
HOMEPAGE="http://common-lisp.net/project/alexandria/"
if [[ ${PV} == 9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://gitlab.common-lisp.net/alexandria/alexandria.git"
else
	SRC_URI="mirror://gentoo/${P}.tar.bz2"
	KEYWORDS="~amd64 ~ppc ~sparc ~x86"
fi

LICENSE="public-domain"
SLOT="0"
IUSE="doc"

DEPEND="doc? ( sys-apps/texinfo )"
RDEPEND=""

src_prepare() {
	eapply "${FILESDIR}/${PN}-fix-docstrings.patch"
	eapply_user
}

src_compile() {
	use doc && emake -C doc
}

src_install() {
	common-lisp-install-sources -t all *.lisp LICENCE
	common-lisp-install-asdf
	dodoc README AUTHORS
	use doc && doinfo doc/${PN}.info && dodoc doc/{"${PN}.html","${PN}.pdf"}
}
