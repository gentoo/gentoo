# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

MY_PN="FlickrNet"

inherit mono multilib

DESCRIPTION="A .Net Library for accessing the Flickr API - Binary version"
HOMEPAGE="http://www.codeplex.com/FlickrNet"

# Upstream download require click-through LGPL-2.1.
# Since the license allows us to do that, just redistribute
# it in a decent format.
SRC_URI="mirror://gentoo/${MY_PN}${PV}.zip"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND=">=dev-lang/mono-2.4"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"

src_compile() { :; }

src_install() {
	egacinstall Release/${MY_PN}.dll ${MY_PN} || die

	# Install .pc file as required by f-spot
	dodir /usr/$(get_libdir)/pkgconfig
	sed -e "s:@VERSION@:${PV}:" \
		-e "s:@LIBDIR@:/usr/$(get_libdir):" \
		"${FILESDIR}"/flickrnet.pc.in > "${D}"/usr/$(get_libdir)/pkgconfig/flickrnet.pc \
		|| die "sed failed"
}
