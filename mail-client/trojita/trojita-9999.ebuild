# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://anongit.kde.org/${PN}.git"
	inherit git-r3
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"
	KEYWORDS="~amd64 ~x86"
fi
inherit cmake-utils virtualx xdg

DESCRIPTION="A Qt IMAP e-mail client"
HOMEPAGE="http://trojita.flaska.net/"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
IUSE="addressbook +crypt +dbus debug +password +spell test +zlib"

REQUIRED_USE="password? ( dbus )"

BDEPEND="
	dev-qt/linguist-tools:5
	test? ( dev-qt/qttest:5 )
	zlib? ( virtual/pkgconfig )
"
DEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	addressbook? ( kde-apps/akonadi-contacts:5 )
	crypt? (
		>=app-crypt/gpgme-1.8.0[cxx,qt5]
		dev-libs/mimetic
	)
	dbus? ( dev-qt/qtdbus:5 )
	password? ( dev-libs/qtkeychain[qt5(+)] )
	spell? ( kde-frameworks/sonnet:5 )
	zlib? ( sys-libs/zlib )
"
RDEPEND="${DEPEND}"

DOCS=( README LICENSE )

src_prepare() {
	cmake-utils_src_prepare

	# the build system is taking a look at `git describe ... --dirty` and
	# gentoo's modifications to CMakeLists.txt break these
	sed -e "s/--dirty//" -i cmake/TrojitaVersion.cmake || die "Cannot fix the version check"
}

src_configure() {
	local mycmakeargs=(
		-DWITH_ABOOKADDRESSBOOK_PLUGIN=ON
		-DWITH_AKONADIADDRESSBOOK_PLUGIN=$(usex addressbook)
		-DWITH_CRYPTO_MESSAGES=$(usex crypt)
		-DWITH_GPGMEPP=$(usex crypt)
		-DWITH_MIMETIC=$(usex crypt)
		-DWITH_DBUS=$(usex dbus)
		-DWITH_QTKEYCHAIN_PLUGIN=$(usex password)
		-DWITH_SONNET_PLUGIN=$(usex spell)
		-DBUILD_TESTING=$(usex test)
		-DWITH_ZLIB=$(usex zlib)
	)

	cmake-utils_src_configure
}

src_test() {
	virtx cmake-utils_src_test
}
