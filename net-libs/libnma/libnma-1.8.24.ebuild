# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="NetworkManager GUI library"
HOMEPAGE="https://wiki.gnome.org/Projects/NetworkManager"

LICENSE="GPL-2+"
SLOT="0"
IUSE="+introspection"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~ia64 ppc ppc64 ~sparc x86"

# This is a transitional package for 1.8.24, but 1.16 version will be a real one split out of nm-applet by upstream
RDEPEND="~gnome-extra/nm-applet-${PV}[introspection?]"
DEPEND="${RDEPEND}"
BDEPEND=""

S="${WORKDIR}"

src_unpack() { :; }
src_install() { :; }
