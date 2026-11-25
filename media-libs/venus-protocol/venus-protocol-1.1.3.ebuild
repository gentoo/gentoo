# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{12..15} )
inherit meson python-any-r1

DESCRIPTION="Virtio-GPU protocol for Vulkan command serialization"
HOMEPAGE="https://gitlab.freedesktop.org/virgl/venus-protocol https://docs.mesa3d.org/drivers/venus.html"
SRC_URI="https://gitlab.freedesktop.org/virgl/venus-protocol/-/archive/v${PV}/venus-protocol-v${PV}.tar.bz2"
S="${WORKDIR}/${PN}-v${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64"

BDEPEND="
	${PYTHON_DEPS}
	$(python_gen_any_dep '
		dev-python/mako[${PYTHON_USEDEP}]
	')
	virtual/pkgconfig
"

PATCHES=(
	"${FILESDIR}"/venus-protocol-1.1.3-arch-independent-pkgconfig.patch # backport
	"${FILESDIR}"/venus-protocol-1.1.3-hookup-tests.patch
)

python_check_deps() {
	python_has_version "dev-python/mako[${PYTHON_USEDEP}]"
}
