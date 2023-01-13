# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A lossless, high performance data compression library"
HOMEPAGE="https://github.com/richgel999/miniz"
SRC_URI="https://github.com/richgel999/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 ~ia64 ppc ppc64 sparc x86"

PATCHES=(
	# https://bugs.gentoo.org/849578
	# https://github.com/richgel999/miniz/pull/239
	"${FILESDIR}"/${PN}-2.2.0-fixpcpath.patch
	"${FILESDIR}"/${PN}-2.2.0-fixincdir.patch
)

DOCS=( ChangeLog.md readme.md )
