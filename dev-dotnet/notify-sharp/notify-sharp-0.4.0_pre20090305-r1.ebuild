# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit autotools eutils mono-env

MY_P=${PN}-${PV#*_pre}

DESCRIPTION="a C# client implementation for Desktop Notifications"
HOMEPAGE="http://www.ndesk.org/NotifySharp"
SRC_URI="mirror://gentoo/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="doc"

RDEPEND=">=dev-lang/mono-1.1.13
	>=dev-dotnet/gtk-sharp-2.10.1
	>=dev-dotnet/dbus-sharp-0.6:1.0
	>=dev-dotnet/dbus-sharp-glib-0.4:1.0
	>=x11-libs/libnotify-0.4.5"
DEPEND="${RDEPEND}"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.4.0_pre20080912-control-docs.patch" \
		"${FILESDIR}/${P}-dbus-sharp.patch"
	sed -i -e 's/gmcs/mcs/' configure.ac || die
	eautoreconf
}

src_configure() {
	econf $(use_enable doc docs)
}
