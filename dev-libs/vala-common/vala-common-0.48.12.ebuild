# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
GNOME_ORG_MODULE="vala"

inherit gnome.org

DESCRIPTION="Build infrastructure for packages that use Vala"
HOMEPAGE="https://wiki.gnome.org/Projects/Vala"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos ~x64-solaris"
IUSE=""

RDEPEND=""
DEPEND=""
BDEPEND=""

src_configure() { :; }

src_compile() { :; }

src_install() {
	insinto /usr/share/aclocal
	doins vala.m4 vapigen/vapigen.m4
	insinto /usr/share/vala
	doins vapigen/Makefile.vapigen
}
