# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake flag-o-matic

DESCRIPTION="An open-source C implementation of the RPKI/Router Protocol client"
HOMEPAGE="https://rtrlib.realmv6.org/"
SRC_URI="https://github.com/rtrlib/rtrlib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86"

IUSE="doc ssh"

RDEPEND="ssh? ( net-libs/libssh:0= )"
DEPEND="
	${RDEPEND}
	doc? ( app-text/doxygen[dot] )
"

src_prepare() {
	# Fix automagic dependency on doxygen, fix path for installing docs
	if use doc; then
		sed -i -e "s:share/doc/rtrlib:share/doc/${PF}:" CMakeLists.txt || die
	else
		sed -i -e '/find_package(Doxygen)/d' CMakeLists.txt || die
	fi
	cmake_src_prepare
}

src_configure() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/861581
	# https://github.com/rtrlib/rtrlib/issues/287
	#
	# Do not trust LTO either.
	append-flags -fno-strict-aliasing
	filter-lto

	local mycmakeargs=(
		-DRTRLIB_TRANSPORT_SSH=$(usex ssh)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	find "${D}" -name '*.la' -delete || die
}
