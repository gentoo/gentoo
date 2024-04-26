# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Collection of general purpose C++-classes"
HOMEPAGE="https://github.com/maekitalo/cxxtools"
SRC_URI="https://github.com/maekitalo/cxxtools/archive/refs/tags/V${PV}.tar.gz -> ${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/libiconv"
DEPEND="${RDEPEND}"

DOCS=( AUTHORS )

PATCHES=(
	"${FILESDIR}"/${P}_gcc11.patch
	"${FILESDIR}"/${PN}-3.0-gcc12-time.patch
	"${FILESDIR}"/${PN}-3.0-lld-linking-openssl.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		--disable-demos \
		$(use_enable test unittest)
}

src_test() {
	emake -C test

	local -x USER=${LOGNAME}
	local -x TZ=UTC # doesn't like e.g. :/etc/timezone
	cd test || die
	./alltests || die
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs

	# remove static libs
	find "${ED}" -name "*.la" -delete || die
}
