# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/_p/-b}"

DESCRIPTION="Design system for interactive fiction"
HOMEPAGE="https://www.inform-fiction.org/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="Artistic-2 Inform"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="emacs"

PDEPEND="emacs? ( app-emacs/inform-mode )"

src_install() {
	default

	dodoc VERSION

	docinto tutorial
	dodoc tutor/README tutor/*.inf

	mv "${ED}"/usr/share/{${PN}/manual,doc/${PF}/html} || die
	rmdir "${ED}"/usr/share/inform/{include,module} || die
	rm "${ED}"/usr/share/inform/6.33b2/include/SmartCantGo.h || die #723062
}
