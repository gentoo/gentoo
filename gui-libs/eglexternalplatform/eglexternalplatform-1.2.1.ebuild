# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="EGL External Platform interface"
HOMEPAGE="https://github.com/NVIDIA/eglexternalplatform/"
SRC_URI="
	https://github.com/NVIDIA/eglexternalplatform/archive/${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64"
