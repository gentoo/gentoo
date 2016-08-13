# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils multilib-minimal

DESCRIPTION="libhal stub forwarding to UDisks for Adobe Flash to play DRM content"
HOMEPAGE="https://github.com/cshorler/hal-flash http://build.opensuse.org/package/show/devel:openSUSE:Factory/hal-flash"
SRC_URI="http://github.com/cshorler/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

COMMON_DEPEND="dev-libs/glib:2=[${MULTILIB_USEDEP},dbus]
	sys-apps/dbus[${MULTILIB_USEDEP}]
	!sys-apps/hal"

RDEPEND="${COMMON_DEPEND}
	sys-fs/udisks"

DEPEND="${COMMON_DEPEND}
	virtual/pkgconfig"

ECONF_SOURCE="${S}"
DOCS="FAQ.txt README"
PATCHES=( "${FILESDIR}"/0001-Make-build-work-outside-of-source-tree.patch )

src_install() {
	multilib-minimal_src_install
	prune_libtool_files
}
