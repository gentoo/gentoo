# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="C++ header-only HTTP/HTTPS server and client library"
HOMEPAGE="https://github.com/yhirose/cpp-httplib"
SRC_URI="https://github.com/yhirose/cpp-httplib/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
