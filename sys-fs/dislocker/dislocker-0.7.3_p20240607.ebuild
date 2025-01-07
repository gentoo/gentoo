# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_REMOVE_MODULES_LIST=( ${CMAKE_REMOVE_MODULES_LIST} FindRuby )
inherit cmake

DESCRIPTION="Dislocker is used to read BitLocker encrypted partitions"
HOMEPAGE="https://github.com/Aorimn/dislocker"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/Aorimn/dislocker.git"
	inherit git-r3
else
	EGIT_COMMIT="3e7aea196eaa176c38296a9bc75c0201df0a3679"
	SRC_URI="https://github.com/Aorimn/dislocker/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE="ruby"

DEPEND="
	sys-fs/fuse:0=
	net-libs/mbedtls:3=
	ruby? ( dev-lang/ruby:* )
"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/dislocker-0.7.3_slotted-mbedtls3.patch"
)

src_prepare() {
	cmake_src_prepare

	# We either need to change Werror to Wno-error or remove the multiple declarations of FORTIFY_SOURCE
	#sed 's:Werror:Wno-error:g' -i "${S}/src/CMakeLists.txt" || die
	sed 's:-D_FORTIFY_SOURCE=2::g' -i "${S}/src/CMakeLists.txt" || die

	# Do not process compressed versions of the manuals
	#sed 's:\.\./man:'../../${P}/man':g' -i "${S}/src/CMakeLists.txt" || die
	sed -r 's:( create_symlink \$\{BIN_FUSE\}\.1)\.gz (.+\.1)\.gz\\:\1 \2\\:' -i "${S}/src/CMakeLists.txt" || die
	sed -r 's:^(.+\.1\.gz):#\1:' -i "${S}/src/CMakeLists.txt" || die
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
