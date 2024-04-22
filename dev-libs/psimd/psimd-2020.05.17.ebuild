# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit cmake

CommitId=072586a71b55b7f8c584153d223e95687148a900
DESCRIPTION="P(ortable) SIMD"
HOMEPAGE="https://github.com/Maratyszcza/psimd/"
SRC_URI="https://github.com/Maratyszcza/${PN}/archive/${CommitId}.tar.gz
	-> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

S="${WORKDIR}"/${PN}-${CommitId}
