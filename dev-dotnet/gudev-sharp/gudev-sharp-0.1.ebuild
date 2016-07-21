# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit mono

DESCRIPTION="GUDEV API C# binding"
HOMEPAGE="https://launchpad.net/gudev-sharp"
SRC_URI="https://launchpad.net/${PN}/trunk/${PV}/+download/${PN}-1.0-${PV}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND=">=dev-dotnet/gtk-sharp-1.9
	>=dev-dotnet/gtk-sharp-gapi-1.9
	virtual/libgudev"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

S=${WORKDIR}/${PN}-1.0-${PV}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS
}
