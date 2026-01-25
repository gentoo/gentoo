# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Partition table rescue/guessing tool"
HOMEPAGE="https://github.com/baruch/gpart"
SRC_URI="https://github.com/baruch/gpart/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~hppa x86"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1h-errno.patch
	"${FILESDIR}"/${PN}-0.3-build.patch
	"${FILESDIR}"/${PN}-0.3-daddr_t.patch
	"${FILESDIR}"/${PN}-0.3-loff_t.patch
)

src_prepare() {
	default

	# Fix version string in build environment.
	if [[ "$(awk -F , '/^AC_INIT/ {print $2}' configure.ac)" != ${PV} ]] ; then
		sed "/^AC_INIT/s@, [[:digit:]\.]\+[[:alnum:]-]*,@, ${PV},@" \
			-i configure.ac || die
	fi

	eautoreconf
}
