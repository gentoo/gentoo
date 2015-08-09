# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

# TODO: This needs to use the escons eclass.
inherit eutils multiprocessing

DESCRIPTION="Direct connect client, looks and works like famous DC++"
HOMEPAGE="https://launchpad.net/linuxdcpp"
SRC_URI="http://launchpad.net/linuxdcpp/1.0/${PV}/+download/${P}.tar.bz2"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE="debug"

RDEPEND=">=gnome-base/libglade-2.4:2.0
	>=x11-libs/gtk+-2.6:2
	app-arch/bzip2
	dev-libs/openssl"
DEPEND="${RDEPEND}
	media-libs/fontconfig
	>=dev-util/scons-0.96
	virtual/pkgconfig"

src_prepare() {
	# prevent scons installation of *txt files to wrong directory
	sed -i 's/.*source = text_files.*//' SConstruct
}

src_compile() {
	local myconf=""
	use debug && myconf="${myconf} debug=1"

	scons ${myconf} -j$(makeopts_jobs) CXXFLAGS="${CXXFLAGS}" PREFIX=/usr || die "scons failed"
}

src_install() {
	# linuxdcpp does not install docs according to gentoos naming scheme, so do it by hand
	dodoc Readme.txt Changelog.txt Credits.txt
	rm "${S}"/*.txt

	scons install PREFIX="/usr" FAKE_ROOT="${D}" || die "scons install failed"

	doicon pixmaps/${PN}.png
	make_desktop_entry ${PN} ${PN}
}

pkg_postinst() {
	elog
	elog "After adding first directory to shares you might need to restart linuxdcpp."
	elog
}
