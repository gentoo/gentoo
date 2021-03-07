# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop elisp-common flag-o-matic xdg

DESCRIPTION="Interactive Geometry Viewer"
HOMEPAGE="http://geomview.sourceforge.net"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.bz2
	https://dev.gentoo.org/~jlec/distfiles/geomview.png.tar"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="motionaveraging debug emacs zlib"

DEPEND="
	virtual/glu
	virtual/opengl
	x11-libs/motif:0
	emacs? ( >=app-editors/emacs-23.1:* )
	zlib? ( sys-libs/zlib )"
RDEPEND="${DEPEND}
	x11-misc/xdg-utils"

S="${WORKDIR}/${P/_/-}"

SITEFILE="50${PN}-gentoo.el"
PATCHES=( "${FILESDIR}"/${PN}-1.9.5-zlib.patch )

src_configure() {
	econf \
		--disable-static \
		--with-htmlbrowser=xdg-open \
		--with-pdfviewer=xdg-open \
		$(use_enable debug d1debug) \
		$(use_with zlib) \
		$(use_enable motionaveraging motion-averaging)
}

src_compile() {
	default

	if use emacs; then
		cp "${FILESDIR}"/gvcl-mode.el . || die
		elisp-compile *.el
	fi
}

src_install() {
	default

	doicon "${WORKDIR}"/geomview.png
	make_desktop_entry ${PN} "GeomView ${PV}" \
		/usr/share/pixmaps/${PN}.png \
		"Science;Math;Education"

	if use emacs; then
		elisp-install ${PN} *.el *.elc
		elisp-site-file-install "${FILESDIR}"/${SITEFILE}
	fi

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}

pkg_postinst() {
	xdg_pkg_postinst
	use emacs && elisp-site-regen
}

pkg_postrm() {
	xdg_pkg_postrm
	use emacs && elisp-site-regen
}
