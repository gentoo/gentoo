# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib-build

DESCRIPTION="Meta package providing the File Alteration Monitor API & Server"
HOMEPAGE="https://www.gnome.org/~veillard/gamin/"
SRC_URI=""

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~m68k ~mips ppc ppc64 ~s390 ~sh sparc x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

RDEPEND="!app-admin/fam
	>=dev-libs/libgamin-0.1.10-r4[${MULTILIB_USEDEP}]"
DEPEND=""

PDEPEND=">=app-admin/gam-server-0.1.10"
