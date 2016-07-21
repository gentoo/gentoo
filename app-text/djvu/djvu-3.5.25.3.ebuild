# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit autotools eutils fdo-mime flag-o-matic

MY_P="${PN}libre-${PV#*_p}"

DESCRIPTION="DjVu viewers, encoders and utilities"
HOMEPAGE="http://djvu.sourceforge.net/"
SRC_URI="mirror://sourceforge/djvu/${MY_P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-solaris"
IUSE="debug doc jpeg tiff xml"

RDEPEND="jpeg? ( virtual/jpeg:0 )
	tiff? ( media-libs/tiff:0= )"
DEPEND="${RDEPEND}
	|| ( gnome-base/librsvg media-gfx/inkscape )"

S=${WORKDIR}/${MY_P%%.3}

src_prepare() {
	sed -i \
		-e 's/AC_CXX_OPTIMIZE/OPTS=;AC_SUBST(OPTS)/' \
		configure.ac || die #263688
	rm aclocal.m4 config/{libtool.m4,ltmain.sh,install-sh,config.sub,config.guess,ltoptions.m4,ltversion.m4,lt~obsolete.m4}
#	epatch "${FILESDIR}/${PN}-3.5.24-gcc46.patch"
	AT_M4DIR="config" eautoreconf
}

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
		newins hi${i}-djvu.png image-vnd.djvu.png
	done
	insinto /usr/share/mime/packages
	doins djvulibre-mime.xml
}

pkg_postinst() {
	fdo-mime_mime_database_update
	has_version app-text/djview || \
		optfeature "For djviewer or browser plugin" app-text/djview
}

pkg_postrm() {
	fdo-mime_mime_database_update
}
