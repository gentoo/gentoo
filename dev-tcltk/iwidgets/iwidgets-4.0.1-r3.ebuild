# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tcltk/iwidgets/iwidgets-4.0.1-r3.ebuild,v 1.3 2013/01/19 10:17:04 ulm Exp $

EAPI=4

inherit eutils multilib

MY_P="${PN}${PV}"
ITCL_MY_P="itcl3.2.1"

DESCRIPTION="Widget collection for incrTcl/incrTk"
HOMEPAGE="http://incrtcl.sourceforge.net/itcl/"
SRC_URI="
	mirror://sourceforge/incrtcl/${MY_P}.tar.gz
	mirror://sourceforge/incrtcl/${ITCL_MY_P}_src.tgz"

LICENSE="HPND Old-MIT tcltk"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux"
IUSE=""

DEPEND="
	>=dev-tcltk/itcl-3.2.1
	>=dev-tcltk/itk-3.2.1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	epatch "${FILESDIR}"/${PV}-path.patch
	sed \
		-e "/^\(LIB\|SCRIPT\)_INSTALL_DIR =/s|lib|$(get_libdir)|" \
		-i Makefile.in || die

	# Bug 115470
	rm doc/panedwindow.n
}

src_configure() {
	econf \
		--with-itcl="${WORKDIR}/${ITCL_MY_P}" \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir) \
		--with-tk="${EPREFIX}"/usr/$(get_libdir)
}

src_compile() {
	:
}

src_install() {
	# parallel borks #177088
	emake -j1 INSTALL_ROOT="${D}" install

	dodoc CHANGES ChangeLog README

	# bug 247184 - iwidget installs man pages in /usr/man
#	mkdir -p "${ED}"/usr/share/man/mann
#	mv "${ED}"/usr/man/mann/* "${ED}"/usr/share/man/mann/
#	rm -rf "${ED}"/usr/man

	# demos are in the wrong place:
#	mkdir -p "${ED}/usr/share/doc/${PF}"
#	mv "${ED}/usr/$(get_libdir)/${MY_P}/demos" "${ED}/usr/share/doc/${PF}/"
}
