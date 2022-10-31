# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{8..11} )

inherit python-any-r1

DESCRIPTION="A SIP connection manager for Telepathy based around the Sofia-SIP library"
HOMEPAGE="https://telepathy.freedesktop.org/"
SRC_URI="https://telepathy.freedesktop.org/releases/${PN}/${P}.tar.gz
	https://patch-diff.githubusercontent.com/raw/TelepathyIM/telepathy-rakia/pull/1.patch
		-> ${P}-py3.patch"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~ia64 ~ppc ~ppc64 ~sparc x86 ~x86-linux"
RESTRICT="test"

COMMON_DEPEND="
	>=dev-libs/dbus-glib-0.60
	>=dev-libs/glib-2.30:2
	>=net-libs/sofia-sip-1.12.11
	>=net-libs/telepathy-glib-0.17.6
	>=sys-apps/dbus-0.60
"
RDEPEND="${COMMON_DEPEND}
	!net-voip/telepathy-sofiasip
"
# telepathy-rakia was formerly known as telepathy-sofiasip
DEPEND="${COMMON_DEPEND}
	${PYTHON_DEPS}
	dev-libs/libxslt
"
# eautoreconf requires: gtk-doc-am

PATCHES=(
	"${DISTDIR}"/${P}-py3.patch
)

src_configure() {
	econf --disable-fatal-warnings
}
