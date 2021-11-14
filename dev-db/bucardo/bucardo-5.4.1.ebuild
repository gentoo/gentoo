# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit perl-module

MY_PN="Bucardo"
DESCRIPTION="An asynchronous PostgreSQL replication system"
HOMEPAGE="http://bucardo.org/wiki/Bucardo"
SRC_URI="http://bucardo.org/downloads/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86"
# doesn't work without extra data
RESTRICT="test"

RDEPEND="dev-perl/DBIx-Safe"
DEPEND="${RDEPEND}
	dev-perl/DBD-Pg"

src_install() {
	emake DESTDIR="${D}" INSTALL_BASE="${D}" install
	keepdir /var/run/bucardo
}
