# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python3_{4,5,6} )

inherit autotools python-single-r1

DESCRIPTION="Library for manipulating and storing storage volume encryption keys"
HOMEPAGE="https://pagure.io/volume_key"
SRC_URI="http://releases.pagure.org/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="test"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	app-crypt/gpgme
	dev-libs/glib:2
	dev-libs/nspr
	dev-libs/nss
	sys-apps/util-linux
	sys-fs/cryptsetup:=
"
DEPEND="
	${RDEPEND}
	sys-devel/gettext
	test? ( dev-libs/nss[utils] )
	"

RESTRICT="test" # possible gpgme issue

PATCHES=(
	"${FILESDIR}"/${P}-config.h.diff
	"${FILESDIR}"/${PN}-0.3.9-find_python.patch

	# Patches from upstream (can usually be removed with next version bump)
	"${FILESDIR}/${P}-cryptsetup2.patch"
)

pkg_setup() {
	python-single-r1_pkg_setup
}

src_prepare() {
	default
	eautoreconf
}
