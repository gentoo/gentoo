# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

if [[ ${PV} = *9999* ]]; then
	EGIT_REPO_URI="https://anongit.kde.org/${PN}.git"
	inherit git-r3
else
	SRC_URI="mirror://sourceforge/${PN}/${P}.tar.xz"
	KEYWORDS="amd64 x86"
fi
inherit cmake virtualx xdg

DESCRIPTION="A Qt IMAP e-mail client"
HOMEPAGE="http://trojita.flaska.net/"

LICENSE="|| ( GPL-2 GPL-3 )"
SLOT="0"
IUSE="+crypt +dbus debug +password test +zlib"

REQUIRED_USE="password? ( dbus )"
RESTRICT="!test? ( test )"

BDEPEND="
	dev-qt/linguist-tools:5
	zlib? ( virtual/pkgconfig )
"
RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtnetwork:5[ssl]
	dev-qt/qtsql:5[sqlite]
	dev-qt/qtsvg:5
	dev-qt/qtwebkit:5
	dev-qt/qtwidgets:5
	crypt? (
		>=app-crypt/gpgme-1.8.0[cxx,qt5]
		dev-libs/mimetic
	)
	dbus? ( dev-qt/qtdbus:5 )
	password? ( dev-libs/qtkeychain[qt5(+)] )
	zlib? ( sys-libs/zlib )
"
DEPEND="${RDEPEND}
	test? ( dev-qt/qttest:5 )
"

DOCS=( README LICENSE )

PATCHES=(
	"${FILESDIR}/${P}-gpgme.patch"
	"${FILESDIR}/${P}-gpg-tests.patch"
	"${FILESDIR}/${P}-qt-5.11b3.patch"
	"${FILESDIR}/${P}-qt-5.13.patch" # bug 730058
	"${FILESDIR}/${P}-qt-5.15.patch"
	"${FILESDIR}/${P}-CVE-2019-10734.patch" # KDE-bug 404697
	"${FILESDIR}/${P}-CVE-2020-15047.patch" # bug 729596
	"${FILESDIR}/${P}-cmake-cxx11.patch"
	"${FILESDIR}/${P}-desktop-spec-namespace.patch"
	"${FILESDIR}/${P}-metainfo.patch" # bug 730140
	"${FILESDIR}/${P}-crash-w-attachments.patch" # KDE-Bug 417697
)

src_prepare() {
	cmake_src_prepare

	# the build system is taking a look at `git describe ... --dirty` and
	# gentoo's modifications to CMakeLists.txt break these
	sed -e "s/--dirty//" -i cmake/TrojitaVersion.cmake || die "Cannot fix the version check"
}

src_configure() {
	local mycmakeargs=(
		-DWITH_RAGEL=OFF # bug 739866, broken by ragel-7
		-DWITH_CRYPTO_MESSAGES=$(usex crypt)
		-DWITH_GPGMEPP=$(usex crypt)
		-DWITH_MIMETIC=$(usex crypt)
		-DWITH_DBUS=$(usex dbus)
		-DWITH_QTKEYCHAIN_PLUGIN=$(usex password)
		-DWITH_TESTS=$(usex test)
		-DWITH_ZLIB=$(usex zlib)
	)

	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}
