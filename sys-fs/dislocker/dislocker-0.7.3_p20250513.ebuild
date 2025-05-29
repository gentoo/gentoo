# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=( ${CMAKE_REMOVE_MODULES_LIST} FindRuby )
inherit cmake

EGIT_COMMIT="4572dc727940cc42249c9f967cee9c505f16b121"

DESCRIPTION="Dislocker is used to read BitLocker encrypted partitions"
HOMEPAGE="https://github.com/Aorimn/dislocker"
SRC_URI="https://github.com/Aorimn/dislocker/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${EGIT_COMMIT}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="ruby"

DEPEND="
	sys-fs/fuse:0=
	net-libs/mbedtls:3=
	ruby? ( dev-lang/ruby:* )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/dislocker-0.7.3_p20250513_mbedtls-3.patch"
)

src_prepare() {
	# Part of dislocker-0.7.3_p20250513_mbedtls-3.patch
	mv include/dislocker/ssl_bindings.h{.in,} || die

	cmake_src_prepare

	# Update cmake_minimum_required
	sed -i -e 's:VERSION 2.6:VERSION 3.10:g' CMakeLists.txt || die

	# We either need to change Werror to Wno-error or remove the multiple declarations of FORTIFY_SOURCE
	#sed 's:Werror:Wno-error:g' -i src/CMakeLists.txt || die
	sed 's:-D_FORTIFY_SOURCE=2::g' -i src/CMakeLists.txt || die

	# Do not process compressed versions of the manuals
	#sed 's:\.\./man:'../../${P}/man':g' -i "${S}/src/CMakeLists.txt" || die
	sed -r 's:( create_symlink \$\{BIN_FUSE\}\.1)\.gz (.+\.1)\.gz\\:\1 \2\\:' -i src/CMakeLists.txt || die
	sed -r 's:^(.+\.1\.gz):#\1:' -i src/CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package ruby Ruby)
	)

	cmake_src_configure
}

src_install() {
	if ! use ruby; then
		rm "${S}/man/linux/${PN}-find.1" || die
	fi

	find "${S}/man/linux" -name '*.1' -exec doman '{}' + || die
	cmake_src_install
}
