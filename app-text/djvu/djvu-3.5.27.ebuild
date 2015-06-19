# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/djvu/djvu-3.5.27.ebuild,v 1.1 2015/03/09 07:57:23 aballier Exp $

EAPI=5
inherit eutils fdo-mime flag-o-matic

MY_P="${PN}libre-${PV#*_p}"

DESCRIPTION="DjVu viewers, encoders and utilities"
HOMEPAGE="http://djvu.sourceforge.net/"
SRC_URI="mirror://sourceforge/djvu/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="debug doc jpeg tiff xml"

RDEPEND="jpeg? ( virtual/jpeg:0 )
	tiff? ( media-libs/tiff:0= )"
DEPEND="${RDEPEND}
	|| ( gnome-base/librsvg media-gfx/inkscape )"

S=${WORKDIR}/${MY_P%%.3}

src_configure() {
	use debug && append-cppflags "-DRUNTIME_DEBUG_ONLY"

	# We install all desktop files by hand.
	econf \
		$(use_enable xml xmltools) \
		$(use_with jpeg) \
		$(use_with tiff) \
		--disable-desktopfiles
}

DOCS=( NEWS README )

src_install() {
	default
	prune_libtool_files

	use doc && dodoc -r doc

	# Install desktop files.
	cd desktopfiles
	for i in {22,32,48,64}; do
		insinto /usr/share/icons/hicolor/${i}x${i}/mimetypes
		newins prebuilt-hi${i}-djvu.png image-vnd.djvu.png
	done
	insinto /usr/share/mime/packages
	doins djvulibre-mime.xml
}

pkg_postinst() {
	fdo-mime_mime_database_update
	if ! has_version app-text/djview; then
		elog "For djviewer or browser plugin, emerge app-text/djview."
	fi
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
