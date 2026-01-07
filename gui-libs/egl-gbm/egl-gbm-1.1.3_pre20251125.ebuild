# Copyright 2021-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson-multilib

DESCRIPTION="NVIDIA GBM EGL external platform library"
HOMEPAGE="https://github.com/NVIDIA/egl-gbm/"

if [[ ${PV} == *_pre* ]]; then
	# happens often that nvidia-drivers ships with a (yet) unreleased
	# version and we need to ship a snapshot to provide the same fixes
	HASH_EGLGBM=a73cbcec5e3911ea6b075df63f6f4e559392926c
	SRC_URI="
		https://github.com/NVIDIA/egl-gbm/archive/${HASH_EGLGBM}.tar.gz
			-> ${P}.tar.gz
	"
	S=${WORKDIR}/${PN}-${HASH_EGLGBM}
else
	SRC_URI="
		https://github.com/NVIDIA/egl-gbm/archive/${PV}.tar.gz
			-> ${P}.tar.gz
	"
fi

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

RDEPEND="
	media-libs/mesa[gbm(+),${MULTILIB_USEDEP}]
	x11-libs/libdrm[${MULTILIB_USEDEP}]
"
DEPEND="
	${RDEPEND}
	>=gui-libs/eglexternalplatform-1.1-r1
	media-libs/libglvnd
"

PATCHES=(
	"${FILESDIR}"/${PN}-1.1.0-werror.patch
)
