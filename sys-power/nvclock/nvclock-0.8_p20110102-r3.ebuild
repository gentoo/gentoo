# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="NVIDIA Overclocking Utility"
HOMEPAGE="http://www.linuxhardware.org/nvclock/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="gtk nvcontrol"

RDEPEND="
	gtk? (
		x11-libs/gtk+:2
		x11-libs/libX11
	)
	nvcontrol? (
		x11-libs/libX11
		x11-libs/libXext
	)"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${P}-r1-make.patch
	"${FILESDIR}"/${P}-usleep.patch
	"${FILESDIR}"/${P}-desktop.patch
	"${FILESDIR}"/${P}-buffers.patch
	"${FILESDIR}"/${P}-fno-common.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	# only <Qt-4 supported
	econf \
		--disable-qt \
		$(use_enable gtk) \
		$(use_enable nvcontrol)
}

src_compile() {
	emake -C src/ nvclock smartdimmer
	use gtk && emake -C src/gtk/
}

src_install() {
	dodir /usr/bin
	default

	newinitd "${FILESDIR}"/nvclock_initd-r1 nvclock
	newconfd "${FILESDIR}"/nvclock_confd nvclock
}

pkg_postinst() {
	elog "To enable card overclocking at startup, edit your /etc/conf.d/nvclock"
	elog "accordingly and then run: rc-update add nvclock default"
}
