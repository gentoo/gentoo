# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="A Large Assortment of Beautiful Themed Icons, Created with FVWM in mind"
HOMEPAGE="http://wm-icons.sourceforge.net/"
SRC_URI="mirror://gentoo/wm-icons-${PV}-cvs-01092003.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 x86"
IUSE=""

RDEPEND="virtual/awk dev-lang/perl"

S=${WORKDIR}/wm-icons

PATCHES=(
	"${FILESDIR}"/${PN}-0.4.0-build.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --enable-icondir="${EPREFIX}"/usr/share/icons/wm-icons
}

src_install() {
	# strange makefile...
	emake icondir="${ED%/}/usr/share/icons/wm-icons" DESTDIR="${D}" install

	rm -rf "${D}"/var

	einfo "Setting default aliases..."
	"${ED%/}/usr/bin/wm-icons-config" --force --user-dir="${ED%/}/usr/share/icons/wm-icons" --defaults || die

	einstalldocs
}

pkg_postinst() {
	einfo "Users can use the wm-icons-config utility to create aliases in their"
	einfo "home directory, FVWM users can then set this in their ImagePath"
	einfo
	einfo "Sample configurations for fvwm1, fvwm2, fvwm95 and scwm are available in"
	einfo "/usr/share/wm-icons"
	einfo
}
