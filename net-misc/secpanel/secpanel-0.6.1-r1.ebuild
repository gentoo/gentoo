# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Graphical frontend for managing and running SSH and SCP connections"
HOMEPAGE="https://themediahost.de/secpanel/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 sparc x86"
IUSE="gif"

DEPEND="!gif? ( virtual/imagemagick-tools )"

RDEPEND="dev-lang/tk
		virtual/ssh"

S=${WORKDIR}/usr/local

src_prepare() {
	# install arch indep stuff in /usr/share instead of /usr/lib*
	sed -i -e '/set libdir/s:../lib:../share:' bin/secpanel || die

	# fix the version
	sed -i -e "/set spversion/s:0.6.0:${PV}:" bin/secpanel || die

	# optionally remove gifs...
	if ! use gif; then
		einfo "Setting secpanel to use PPM images"
		sed -i -e 's/\.gif/\.ppm/g' bin/secpanel || die

		einfo "Converting all GIF images to PPM format..."
		for i in $(find lib/secpanel/images -name "*.gif") ; do
			einfo "convert ${i} => ${i//.gif/.ppm}"
			convert "${i}" "ppm:${i//.gif/.ppm}" || die
			rm -v "${i}" || die
		done
	fi

	eapply_user
}

src_install() {
	dobin bin/secpanel

	insinto /usr/share/secpanel
	doins -r lib/secpanel/{*.{tcl,config,profile,wait,txt,sh},images,spdistkey}
}
