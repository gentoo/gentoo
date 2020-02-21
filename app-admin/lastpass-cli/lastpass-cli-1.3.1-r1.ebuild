# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils bash-completion-r1

DESCRIPTION="Interfaces with LastPass.com from the command line."
HOMEPAGE="https://github.com/lastpass/lastpass-cli"
SRC_URI="https://github.com/lastpass/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz
	https://dev.gentoo.org/~gokturk/distfiles/app-admin/lastpass-cli/${PN}-man-${PV}.tar.xz"

SLOT="0"
LICENSE="GPL-2+ GPL-2+-with-openssl-exception"
KEYWORDS="amd64 x86"
IUSE="libressl X +pinentry test"
RESTRICT="!test? ( test )"

RDEPEND="
	X? ( || ( x11-misc/xclip x11-misc/xsel ) )
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-misc/curl
	dev-libs/libxml2
	pinentry? ( app-crypt/pinentry )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DBASH_COMPLETION_COMPLETIONSDIR="$(get_bashcompdir)"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile all $(usex test lpass-test '')
}

src_install() {
	cmake-utils_src_install install

	doman "${WORKDIR}"/man/lpass.1
}

src_test() {
	local myctestargs=(
		-j1 # Parallel tests fail
	)

	# The path to lpass-test is hardcoded to "${S}"/build/lpass-test
	# which is incorrect for our out-of-source build
	sed -e "s|TEST_LPASS=.*|TEST_LPASS=\"${BUILD_DIR}/lpass-test\"|" \
		-i "${S}"/test/include.sh || die

	cmake-utils_src_test
}
