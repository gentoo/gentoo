# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit desktop xdg

DESCRIPTION="GUI tool used to make the management of Pure-FTPd a little easier"
HOMEPAGE="http://purify.sourceforge.net/"
SRC_URI="mirror://sourceforge/purify/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="doc"

RDEPEND="
	gnome-base/libglade:2.0
	sys-libs/zlib
	virtual/fam
	x11-libs/gtk+:2
	x11-libs/libX11"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-gold.patch
	"${FILESDIR}"/${P}-QA-desktop-file.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default

	# prevent "make check" from complaining
	cat >> po/POTFILES.skip <<- EOF || die
		src/eggstatusicon.c
		src/eggtrayicon.c
		src/prereq_usrmanager.c
	EOF
}

src_install() {
	default

	# Move the docs to the correct location, if we want the docs
	use doc &&
		dodoc -r "${ED}"/usr/share/pureadmin/docs/.
	rm -Rv "${ED}"/usr/share/pureadmin/docs || die

	make_desktop_entry pureadmin "Pure-FTPd menu config" pureadmin
}

pkg_postinst() {
	ewarn "PureAdmin is at a beta-stage right now and it may break your"
	ewarn "configuration. DO NOT use it for safety critical system"
	ewarn "or production use!"

	elog
	elog "You need root-privileges to be able to use PureAdmin."
	elog "This will probably change in the future."
	elog
}
