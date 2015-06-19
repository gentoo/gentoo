# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-gfx/printrun/printrun-20140730.ebuild,v 1.4 2014/08/10 14:01:06 amynka Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="GUI interface for 3D printing on RepRap and other printers"
HOMEPAGE="https://github.com/kliment/Printrun"
SRC_URI="https://github.com/kliment/Printrun/archive/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/pyserial
	dev-python/wxpython
	dev-python/pyglet
	dev-python/dbus-python
	media-gfx/cairosvg"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/printrun-no-py-in-binaries.patch"
)

S="${WORKDIR}/Printrun-${P}"
