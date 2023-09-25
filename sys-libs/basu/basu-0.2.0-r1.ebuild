# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..10} )
inherit meson python-any-r1

DESCRIPTION="The sd-bus library, extracted from systemd"
HOMEPAGE="https://sr.ht/~emersion/basu/"
LICENSE="LGPL-2.1+"
SLOT="0"

SRC_URI="https://git.sr.ht/~emersion/basu/refs/download/v${PV}/basu-${PV}.tar.gz"
KEYWORDS="amd64"

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
	"${FILESDIR}"/0001-"${PN}"-0.2.0-meson-add-libcap-option.patch
	"${FILESDIR}"/0002-"${PN}"-0.2.0-meson-convert-audit-option-to-feature-object.patch
	"${FILESDIR}"/0001-"${PN}"-0.2.0-LLD-13-and-GNU-ld-2.37-support-z-start-stop-gc-which.patch
	"${FILESDIR}"/0002-"${PN}"-0.2.0-meson-fix-linking-on-LLD-13-LD-2.37-and-older-CCs.patch
)

src_configure() {
	local emesonargs=(
		$(meson_feature audit)
		$(meson_feature caps libcap)
	)
	meson_src_configure
}
