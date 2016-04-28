# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="Integrates Pidgin (and libpurple) with the system keyring"
HOMEPAGE="https://github.com/aebrahim/pidgin-gnome-keyring"
SRC_URI="https://github.com/aebrahim/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="app-crypt/libsecret
	net-im/pidgin"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-plugindir.patch"
)

src_prepare() {
	default

	# This file is used by the upstream Makefile yet is missing from at least
	# some release tarballs.
	if [ ! -f VERSION ]; then
		echo "${PV}" > VERSION || die "failed to recreate VERSION file"
	fi

	sed -i \
		-e 's|-O2||g' \
		-e 's|-ggdb||g' \
		-e 's|-g||g' \
		Makefile || die "stripping hard-coded flags failed"
}
