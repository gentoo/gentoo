# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{6,7} )

inherit python-single-r1

DESCRIPTION="Library for manipulating and storing storage volume encryption keys"
HOMEPAGE="https://pagure.io/volume_key"
SRC_URI="http://releases.pagure.org/${PN}/${P}.tar.xz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
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

pkg_setup() {
	python-single-r1_pkg_setup
}

src_configure() {
	# --without-python disables python2
	econf --without-python --with-python3
}

src_install() {
	default
	find "${ED}" -name "*.la" -delete || die
}
