# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="KFaenza"
DESCRIPTION="Faenza-Cupertino icon theme for KDE Plasma"
HOMEPAGE="https://store.kde.org/p/1002580/
	https://kde-look.org/content/show.php/KFaenza+icon+patch?content=153813
	https://kde-look.org/content/show.php/Additional+KFaenza+Icons?content=147483"
#That is upstream location, not reupload. Don't fix
SRC_URI="http://ompldr.org/vYjR0NQ/${P}.tar.gz
	http://kde-look.org/CONTENT/content-files/153813-${PN}-icon-patch-0.3.tar.gz
	additional? ( http://kde-look.org/CONTENT/content-files/147483-additional-KFaenza.tar.gz )"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+additional branding"

S="${WORKDIR}/${MY_PN}"
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
	default

	# Gentoo bug 620352
	local f
	for f in 16 22 32 48; do
		mv apps/${f}/"numpty physics.png" apps/${f}/"numptyphysics.png" || die
	done

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
