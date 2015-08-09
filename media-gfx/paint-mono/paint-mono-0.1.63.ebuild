# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit mono multilib

DESCRIPTION="An unofficial effort to port Paint.NET 3.0 to Linux using Mono"
HOMEPAGE="http://code.google.com/p/paint-mono/"
SRC_URI="http://${PN}.googlecode.com/files/paintdotnet-${PV}.tar.gz"

LICENSE="MIT CC-BY-NC-ND-2.5"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=dev-lang/mono-2.4[-minimal]"
RDEPEND="${DEPEND}"

S="${WORKDIR}/paintdotnet-${PV}"

src_configure() {
	./configure --prefix=/usr
}

src_install() {
	emake DESTDIR="${D}" install
	mono_multilib_comply
	sed -i -e 's:usr/local:usr:' "${D}"/usr/$(get_libdir)/pkgconfig/* "${D}"/usr/bin/*
}
