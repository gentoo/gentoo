# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit readme.gentoo-r1

DESCRIPTION="A Large Assortment of Beautiful Themed Icons, Created with FVWM in mind"
HOMEPAGE="http://wm-icons.sourceforge.net/"
SRC_URI="mirror://sourceforge/wm-icons/wm-icons-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ia64 ~ppc ~ppc64 ~x86"
IUSE=""

RDEPEND="
	app-alternatives/awk
	dev-lang/perl
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-build.patch )

DOC_CONTENTS="
	Users can use the wm-icons-config utility to create aliases in their
	home directory, FVWM users can then set this in their ImagePath.
	Sample configurations for fvwm1, fvwm2, fvwm95 and scwm are available in
	/usr/share/wm-icons
"

src_configure() {
	econf \
		--enable-all-sets \
		--enable-icondir="${EPREFIX}"/usr/share/icons/wm-icons
}

src_install() {
	# strange makefile...
	emake icondir="${ED}/usr/share/icons/wm-icons" DESTDIR="${D}" install

	einfo "Setting default aliases..."
	"${ED}/usr/bin/wm-icons-config" --force --user-dir="${ED}/usr/share/icons/wm-icons" --defaults || die

	einstalldocs
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
