# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit elisp-common eutils flag-o-matic fdo-mime

DESCRIPTION="Interactive Geometry Viewer"
HOMEPAGE="http://geomview.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.bz2
	http://dev.gentoo.org/~jlec/distfiles/geomview.png.tar"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
LICENSE="LGPL-2.1"
SLOT="0"
IUSE="motionaveraging debug emacs zlib"

DEPEND=">=x11-libs/motif-2.3:0
	virtual/glu
	virtual/opengl
	emacs? ( virtual/emacs )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	x11-misc/xdg-utils"

S="${WORKDIR}/${P/_/-}"

SITEFILE=50${PN}-gentoo.el

src_configure() {
	econf --docdir=/usr/share/doc/${PF} \
		--with-htmlbrowser=xdg-open \
		--with-pdfviewer=xdg-open \
		$(use_enable debug d1debug) \
		$(use_with zlib) \
		$(use_enable motionaveraging motion-averaging)
}

src_compile() {
	default
	if use emacs; then
		cp "${FILESDIR}/gvcl-mode.el" "${S}"
		elisp-compile *.el
	fi
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog NEWS INSTALL.Geomview || die
	doicon "${WORKDIR}"/geomview.png || die
	make_desktop_entry ${PN} "GeomView ${PV}" \
		/usr/share/pixmaps/${PN}.png \
		"Science;Math;Education"

	if use emacs; then
		elisp-install ${PN} *.el *.elc
		elisp-site-file-install "${FILESDIR}/${SITEFILE}"
	fi
}

pkg_postinst() {
	fdo-mime_desktop_database_update
	use emacs && elisp-site-regen
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	use emacs && elisp-site-regen
}
