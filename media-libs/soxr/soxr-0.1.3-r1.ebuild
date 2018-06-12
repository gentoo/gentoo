# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-multilib

MY_P="${P}-Source"
DESCRIPTION="SoX Resampler library"
HOMEPAGE="https://sourceforge.net/p/soxr/wiki/Home/"
SRC_URI="mirror://sourceforge/soxr/${MY_P}.tar.xz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd"
IUSE="examples test"

# CMakeLists.txt builds examples if either test or examples USE flag is enabled.
REQUIRED_USE="test? ( examples )"

DEPEND=""
RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

DOCS=( README TODO NEWS AUTHORS )

PATCHES=(
	"${FILESDIR}/${PN}-0.1.1-nodoc.patch"
	"${FILESDIR}/${P}-fix-pkgconfig.patch"
)

src_configure() {
	local mycmakeargs=(
		-DBUILD_EXAMPLES="$(usex examples)"
		-DBUILD_TESTS="$(usex test)"
	)
	if use examples ; then
		mycmakeargs+=(
			-DDOC_INSTALL_DIR="/usr/share/doc/${PF}"
		)
	fi
	cmake-multilib_src_configure
}

src_install() {
	cmake-multilib_src_install
	if use examples ; then
		docompress -x /usr/share/doc/${PF}/examples
	fi
}
