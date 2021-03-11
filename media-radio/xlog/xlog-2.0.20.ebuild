# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools toolchain-funcs xdg-utils
MY_P=${P/_}

DESCRIPTION="An amateur radio logging program"
HOMEPAGE="https://www.nongnu.org/xlog"
SRC_URI="https://download.savannah.gnu.org/releases/${PN}/${MY_P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="media-libs/hamlib:=
	dev-libs/glib:2
	x11-libs/gtk+:2"
DEPEND="${RDEPEND}
	media-libs/libpng:0
	sys-devel/gettext
	virtual/pkgconfig"

S=${WORKDIR}/${MY_P}

DOCS=( AUTHORS data/doc/THANKS NEWS README )

src_prepare() {
	eapply -p0 "${FILESDIR}/${PN}-2.0.7-desktop.patch"

	# Let portage handle updating mime/desktop databases,
	eapply -p0 "${FILESDIR}/${PN}-2.0.13-desktop-update.patch"
	# Drop -Werror
	sed -i -e "s:-Werror::" configure.ac || die
	# fix underlinking
	sed -i -e "s:HAMLIB_LIBS@:HAMLIB_LIBS@ -lm:g" src/Makefile.am || die
	eautoreconf

	# Fix broken png files<<
	einfo "Fixing broken png files."
	pushd "${S}"/data/doc/manual/output/html
	for png in xlog-clock.png xlog-dropdown.png xlog-editbox.png; do
		pngfix -q --out=out.png ${png}
		mv -f out.png "${png}" || die
	done
	popd
	einfo "done ..."

	eapply_user
}

src_configure() {
	# mime-update causes file collisions if enabled
	econf --disable-mime-update --disable-desktop-update
}

src_compile() {
	emake AR="$(tc-getAR)"
}

src_install() {
	emake DESTDIR="${D}" install
	docompress -x /usr/share/doc/${PF}/{KEYS,ChangeLog,TODO,BUGS}
	einstalldocs
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
}
