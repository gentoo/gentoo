# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-themes/kfaenza/kfaenza-0.8.9-r1.ebuild,v 1.2 2013/04/26 18:06:44 scarabeus Exp $

EAPI=4

MY_PN="KFaenza"
DESCRIPTION="Faenza-Cupertino icon theme for KDE"
HOMEPAGE="http://kde-look.org/content/show.php/KFaenza?content=143890 http://kde-look.org/content/show.php/KFaenza+icon+patch?content=153813 http://kde-look.org/content/show.php/Additional+KFaenza+Icons?content=147483"
#That is upstream location, not reupload. Don't fix
SRC_URI="http://ompldr.org/vYjR0NQ/${P}.tar.gz
	http://kde-look.org/CONTENT/content-files/153813-kfaenza-icon-patch-0.3.tar.gz
	additional? ( http://kde-look.org/CONTENT/content-files/147483-additional-KFaenza.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+additional branding"

S="${WORKDIR}"/"${MY_PN}"
RESTRICT="binchecks strip"

src_unpack() {
	unpack ${P}.tar.gz
	pushd "${S}" > /dev/null
	for tarball in ${A}; do
		[[ "${tarball}" == ${P}.tar.gz ]] && continue
		unpack "${tarball}"
	done
	popd > /dev/null
}

src_prepare() {
	use branding || return

	local res
	for res in 22 32 48 64 128 256; do
		cp "${S}"/places/${res}/start-here-gentoo.png \
			"${S}"/places/${res}/start-here.png || die
	done
	cp "${S}"/places/scalable/start-here-gentoo.svg \
		"${S}"/places/scalable/start-here.svg || die
}

src_install() {
	dodir /usr/share/icons
	cp -R "${S}/" "${D}"/usr/share/icons || die "Install failed!"
}
