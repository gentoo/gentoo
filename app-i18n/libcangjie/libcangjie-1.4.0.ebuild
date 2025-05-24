# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Library implementing the Cangjie input method"
HOMEPAGE="https://cangjie.pages.freedesktop.org/projects/libcangjie/"
# dist tarball seems missing here
SRC_URI="https://gitlab.freedesktop.org/cangjie/libcangjie/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
S="${WORKDIR}"/${PN}-v${PV}

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="dev-db/sqlite:3"
DEPEND="${RDEPEND}"
BDEPEND=">=dev-build/meson-1.3.2"
