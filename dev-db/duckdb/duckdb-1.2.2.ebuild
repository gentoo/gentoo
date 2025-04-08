# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="high-performance analytical database system"
HOMEPAGE="https://duckdb.org https://github.com/duckdb/duckdb"

SRC_URI="https://github.com/duckdb/duckdb/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64"

RESTRICT="test"

src_configure() {
	mycmakeargs=( "-DINSTALL_LIB_DIR=/usr/$(get_libdir)/"
		"-DOVERRIDE_GIT_DESCRIBE=v${PV}"
		"-DBUILD_EXTENSIONS='autocomplete;icu;tpch;tpcds;json;jemalloc'"
		"-DCXX_EXTRA=${CXXFLAGS}"
		)
	cmake_src_configure
}
