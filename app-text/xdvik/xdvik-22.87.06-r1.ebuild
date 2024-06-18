# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools desktop elisp-common flag-o-matic toolchain-funcs xdg

DESCRIPTION="DVI viewer for X Window System"
HOMEPAGE="https://xdvi.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/xdvi/${P}.tar.gz
	https://dev.gentoo.org/~pacho/${PN}/${PN}_192.png"
S="${WORKDIR}"/${P}/texk/xdvik

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

IUSE="motif neXt Xaw3d emacs"

DEPEND=">=media-libs/freetype-2.9.1-r2:2
	x11-libs/libX11
	x11-libs/libXi
	x11-libs/libXmu
	x11-libs/libXpm
	x11-libs/libXt
	emacs? ( >=app-editors/emacs-23.1:* )
	motif? ( >=x11-libs/motif-2.3:0 )
	!motif? (
		neXt? ( x11-libs/neXtaw )
		!neXt? (
			Xaw3d? ( x11-libs/libXaw3d )
			!Xaw3d? ( x11-libs/libXaw )
		)
	)
	dev-libs/kpathsea:="
RDEPEND="${DEPEND}
	virtual/latex-base
"
BDEPEND="app-alternatives/lex
	app-alternatives/yacc
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-22.87.06-configure-clang16.patch
	"${FILESDIR}"/${PN}-22.87.06-c99-fix.patch
)

src_prepare() {
	default

	# Make sure system kpathsea headers are used
	cd "${WORKDIR}/${P}/texk/kpathsea" || die
	local i
	for i in *.h ; do
		echo "#include_next \"$i\"" > ${i} || die
	done

	cd "${WORKDIR}/${P}" || die
	cd "${S}" || die
	eautoreconf
}

src_configure() {
	has_version '>=dev-libs/kpathsea-6.2.1' && append-cppflags "$($(tc-getPKG_CONFIG) --cflags kpathsea)"

	local toolkit
	if use motif ; then
		toolkit="motif"
		use neXt && ewarn "neXt USE flag ignored (superseded by motif)"
		use Xaw3d && ewarn "Xaw3d USE flag ignored (superseded by motif)"
	elif use neXt ; then
		toolkit="neXtaw"
		use Xaw3d && ewarn "Xaw3d USE flag ignored (superseded by neXt)"
	elif use Xaw3d ; then
		toolkit="xaw3d"
	else
		toolkit="xaw"
	fi

	econf \
		--with-system-freetype2 \
		--with-system-kpathsea \
		--with-kpathsea-include="${EPREFIX}"/usr/include/kpathsea \
		--with-xdvi-x-toolkit="${toolkit}" \
		--x-includes="${ESYSROOT}"/usr/include \
		--x-libraries="${ESYSROOT}"/usr/$(get_libdir)
}

src_compile() {
	emake kpathsea_dir="${EPREFIX}"/usr/include/kpathsea

	use emacs && elisp-compile xdvi-search.el
}

src_install() {
	dodir /usr/share/texmf-dist/dvips/config

	emake DESTDIR="${D}" install

	dosym ../../texmf-dist/xdvi/XDvi /usr/share/X11/app-defaults/XDvi

	dodoc BUGS FAQ README.*

	use emacs && elisp-install tex-utils *.el *.elc

	doicon "${FILESDIR}"/${PN}.xpm
	newicon -s 192 "${DISTDIR}"/${PN}_192.png ${PN}.png
	make_desktop_entry "xdvi %f" "XDvi" xdvik "Graphics;Viewer" "MimeType=application/x-dvi;"
	# Our desktop file is more complete
	rm "${ED}/usr/share/applications/xdvi.desktop" || die
}

pkg_postinst() {
	xdg_pkg_postinst

	if use emacs; then
		elog "Add"
		elog "	(add-to-list 'load-path \"${EPREFIX}${SITELISP}/tex-utils\")"
		elog "	(require 'xdvi-search)"
		elog "to your ~/.emacs file"
	fi
}
