# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="An open-source C implementation of the RPKI/Router Protocol client"
HOMEPAGE="https://rtrlib.realmv6.org/"
SRC_URI="https://github.com/rtrlib/rtrlib/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE="doc ssh"

RDEPEND="ssh? ( net-libs/libssh:0= )"
DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen[dot] )
"

src_prepare() {
	# Fix checks for libssh version
	sed -i \
		-e 's:/libssh/libssh.h:/libssh/libssh_version.h:g' \
		cmake/modules/FindLibSSH.cmake || die
	# Fix automagic dependency on doxygen, fix path for installing docs
	if use doc; then
		sed -i -e "s:share/doc/rtrlib:share/doc/${PF}:" CMakeLists.txt || die
	else
		sed -i -e '/find_package(Doxygen)/d' CMakeLists.txt || die
	fi
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DRTRLIB_TRANSPORT_SSH=$(usex ssh)
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	find "${D}" -name '*.la' -delete || die
}
