# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake readme.gentoo-r1

DESCRIPTION="Greenbone Library for helper functions in PostgreSQL"
HOMEPAGE="https://www.greenbone.net https://github.com/greenbone/pg-gvm"
SRC_URI="https://github.com/greenbone/pg-gvm/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="amd64 ~x86"

# Tests requires a running database that match up with the current
# testing slot. Won't run from ${ED}, want's to install too early.
RESTRICT="test"

DEPEND="
	>=dev-libs/glib-2.42:2
	>=dev-libs/libical-1.0.0:=
	>=net-analyzer/gvm-libs-22.6
"

RDEPEND="
	${DEPEND}
	>=dev-db/postgresql-9.6:=[uuid]
"

src_install() {
	cmake_src_install
	readme.gentoo_create_doc
}

pkg_postinst() {
	readme.gentoo_print_elog
}
