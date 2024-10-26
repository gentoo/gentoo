# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/dosbox-libretro"
inherit flag-o-matic libretro-core

DESCRIPTION="DOSBox libretro port"
LICENSE="GPL-2+"
SLOT="0"

src_compile() {
	# -Werror=strict-aliasing
	# https://bugs.gentoo.org/858707
	#
	# Yet another unmaintained dosbox fork inheriting the bugs of dosbox.
	# No point reporting.
	append-flags -fno-strict-aliasing
	filter-lto

	append-cxxflags -std=gnu++11
	default
}
