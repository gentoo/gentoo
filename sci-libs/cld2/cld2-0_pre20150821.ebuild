# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

MY_COMMIT="b56fa78a2fe44ac2851bae5bf4f4693a0644da7b"
DESCRIPTION="Compact Language Detector 2"
HOMEPAGE="https://github.com/CLD2Owners/cld2"
SRC_URI="https://github.com/CLD2Owners/cld2/archive/${MY_COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${MY_COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}/${PN}-0_pre20150821_add-cmake-file.patch" )
