# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit flag-o-matic cmake

DESCRIPTION="Neko is a high-level dynamically typed programming language"
HOMEPAGE="https://nekovm.org/
	https://github.com/HaxeFoundation/neko/"

if [[ "${PV}" == *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/HaxeFoundation/${PN}.git"
else
	# 2.3.0 -> 2-3-0
	MY_PV="${PV//./-}"
	SRC_URI="https://github.com/HaxeFoundation/${PN}/archive/refs/tags/v${MY_PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
	S="${WORKDIR}/${PN}-${MY_PV}"
fi

LICENSE="MIT"
SLOT="0/${PV}"
IUSE="apache mysql sqlite ssl"

RDEPEND="
	dev-libs/boehm-gc:=[threads]
	dev-libs/libpcre:=
	sys-libs/zlib:=
	apache? ( www-servers/apache:2= )
	mysql? ( dev-db/mysql:= )
	sqlite? ( dev-db/sqlite:3= )
	ssl? (
		dev-libs/openssl:=
		net-libs/mbedtls:=
	)
"
DEPEND="${RDEPEND}"

src_configure() {
	# -Werror=strict-aliasing warnings, bug #855641
	filter-lto
	append-flags -fno-strict-aliasing

	local mycmakeargs=(
		-DRUN_LDCONFIG=OFF
		-DWITH_NEKOML=ON
		-DWITH_REGEXP=ON
		-DWITH_UI=OFF
		-DWITH_APACHE=$(usex apache)
		-DWITH_MYSQL=$(usex mysql)
		-DWITH_SQLITE=$(usex sqlite)
		-DWITH_SSL=$(usex ssl)
	)
	cmake_src_configure
}
