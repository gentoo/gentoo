# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-utils flag-o-matic

DESCRIPTION="Dislocker is used to read BitLocker encrypted partitions."
HOMEPAGE="https://github.com/Aorimn/dislocker"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/Aorimn/dislocker.git"
	inherit git-r3
else
	SRC_URI="https://github.com/Aorimn/dislocker/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="ruby"

DEPEND="
	sys-fs/fuse:0=
	net-libs/mbedtls:0=
	ruby? ( dev-lang/ruby:* )
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake-utils_src_prepare

# We either need to change Werror to Wno-error or remove the multiple declarations of FORTIFY_SOURCE
#    sed 's:Werror:Wno-error:g' -i "${S}/src/CMakeLists.txt" || die
	sed 's:-D_FORTIFY_SOURCE=2::g' -i "${S}/src/CMakeLists.txt" || die

	sed 's:\.\./man:'../../${P}/man':g' -i "${S}/src/CMakeLists.txt" || die
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_find_package ruby Ruby)
	)
	cmake-utils_src_configure
}

src_install() {
	find "${S}/man/linux" -name '*.1' -exec doman '{}' +
	cmake-utils_src_install
}
