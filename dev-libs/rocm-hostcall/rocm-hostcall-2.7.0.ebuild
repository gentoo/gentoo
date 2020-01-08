# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/"
	inherit git-r3
	S="${WORKDIR}/${P}/lib/hostcall"
else
	SRC_URI="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport/archive/roc-${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/ROCm-CompilerSupport-roc-${PV}/lib/hostcall"
	KEYWORDS="~amd64"
fi
PATCHES=(
	"${FILESDIR}/${P}-install-correctly.patch"
)

DESCRIPTION="Radeon Open Compute hostcall API"
HOMEPAGE="https://github.com/RadeonOpenCompute/ROCm-CompilerSupport"
LICENSE="MIT"
SLOT="0/$(ver_cut 1-2)"

RDEPEND="dev-libs/rocr-runtime"
DEPEND="${RDEPEND}"
