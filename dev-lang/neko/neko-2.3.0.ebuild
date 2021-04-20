# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="Neko is a high-level dynamically typed programming language"
HOMEPAGE="https://nekovm.org/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/HaxeFoundation/${PN}.git"
else
	# 2.3.0 -> 2-3-0
	MY_PV="${PV//./-}"
	SRC_URI="https://github.com/HaxeFoundation/${PN}/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MIT"
SLOT="0"
IUSE="apache mysql sqlite ssl"

DEPEND="
	apache? ( www-servers/apache:2 )
	mysql? ( dev-db/mysql:* )
	sqlite? ( dev-db/sqlite )
	ssl? ( dev-libs/openssl )
	dev-libs/boehm-gc
	dev-libs/libpcre
	sys-libs/zlib
"
RDEPEND="${DEPEND}"

src_configure() {
	local mycmakeargs=(
		-DRUN_LDCONFIG=OFF
		-DWITH_UI=OFF
		-DWITH_NEKOML=ON
		-DWITH_REGEXP=ON
		-DWITH_APACHE=$(usex apache)
		-DWITH_MYSQL=$(usex mysql)
		-DWITH_SQLITE=$(usex sqlite)
		-DWITH_SSL=$(usex ssl)
	)
	cmake_src_configure
}
