# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="M(easuring)buffer is a replacement for buffer with additional functionality"
HOMEPAGE="https://www.maier-komor.de/mbuffer.html"
SRC_URI="https://www.maier-komor.de/software/mbuffer/${P}.tgz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~x86"
IUSE="debug libressl ssl test"

REQUIRED_USE="test? ( ssl )"

RESTRICT="!test? ( test )"

RDEPEND="ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${PN}-20180410-sysconfdir.patch"
	"${FILESDIR}/${PN}-20200929-find-OBJDUMP.patch"
)

src_prepare() {
	ln -s "${DISTDIR}"/${P}.tgz test.tar #258881

	default

	mv configure.in configure.ac || die

	eautoreconf
}

src_configure() {
	local myeconfargs=(
		$(use_enable ssl md5)
		$(use_enable debug)
	)
	econf "${myeconfargs[@]}"
}

src_test() {
	if has usersandbox ${FEATURES} || has network-sandbox ${FEATURES}; then
		ewarn "Some tests may fail with FEATURES=usersandbox or"
		ewarn "FEATURES=network-sandbox; Skipping tests because"
		ewarn "test suite would hang forever in such environments!"
		return 0;
	fi

	# Enforce MAKEOPTS=-j1 because src_test() spawns multiple listener
	# using same port and src_install may have problems (with /etc folder)
	local -x MAKEOPTS=-j1

	default
}

pkg_postinst() {
	if ! has_version "app-arch/mt-st"; then
		elog ""
		elog "If you want autoloader support you need to install \"app-arch/mt-st\" in addition!"
	fi
}
