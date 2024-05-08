# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 cmake

DESCRIPTION="ANSI C General Decimal Arithmetic Library"
HOMEPAGE="https://github.com/SDL-Hercules-390/decNumber"
EGIT_REPO_URI="https://github.com/SDL-Hercules-390/decNumber"

LICENSE="icu"
SLOT="0"
PATCHES=( "${FILESDIR}/cmakefix.patch" )
