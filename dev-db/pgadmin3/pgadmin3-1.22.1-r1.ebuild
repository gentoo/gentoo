# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit eutils multilib versionator wxwidgets

DESCRIPTION="wxWidgets GUI for PostgreSQL"
HOMEPAGE="http://www.pgadmin.org/"
SRC_URI="mirror://postgresql/${PN}/release/v${PV}/src/${P}.tar.gz"

LICENSE="POSTGRESQL"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
SLOT="0"
IUSE="debug +databasedesigner"

DEPEND="
	x11-libs/wxGTK:3.0=[X]
	>=dev-db/postgresql-8.4.0:=
	>=dev-libs/libxml2-2.6.18
	>=dev-libs/libxslt-1.1"
RDEPEND="${DEPEND}"

pkg_setup() {
	local pgslot=$(postgresql-config show)

	if [[ ${pgslot//.} < 84 ]] ; then
		eerror "PostgreSQL slot must be set to 8.4 or higher."
		eerror "    postgresql-config set 8.4"
		die "PostgreSQL slot is not set to 8.4 or higher."
	fi
}

src_prepare() {
	epatch "${FILESDIR}/pgadmin3-desktop.patch"

	epatch_user
}

src_configure() {
	WX_GTK_VER="3.0"

	setup-wxwidgets

	econf --with-wx-version=${WX_GTK_VER} \
		$(use_enable debug) \
		$(use_enable databasedesigner)
}

src_install() {
	emake DESTDIR="${D}" install

	newicon "${S}/pgadmin/include/images/pgAdmin3.png" ${PN}.png

	domenu "${S}/pkg/pgadmin3.desktop"

	# Fixing world-writable files
	fperms -R go-w /usr/share
}
