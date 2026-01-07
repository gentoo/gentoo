# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
inherit meson python-any-r1

DESCRIPTION="The sd-bus library, extracted from systemd"
HOMEPAGE="https://sr.ht/~emersion/basu/"
SRC_URI="https://git.sr.ht/~emersion/basu/refs/download/v${PV}/basu-${PV}.tar.gz"
LICENSE="LGPL-2.1+"
SLOT="0"

KEYWORDS="amd64 ~arm64"
IUSE="audit caps"

DEPEND="
	audit? ( sys-process/audit )
	caps? ( sys-libs/libcap )
"

RDEPEND="${DEPEND}"
# Needed to generate hash tables
BDEPEND="${PYTHON_DEPS}
	dev-util/gperf
"

PATCHES=(
	"${FILESDIR}"/${P}-fix_lld.patch #918937
)

src_configure() {
	local emesonargs=(
		$(meson_feature audit)
		$(meson_feature caps libcap)
	)
	meson_src_configure
}
