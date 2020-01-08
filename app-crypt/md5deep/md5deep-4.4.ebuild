# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Expanded md5sum program with recursive and comparison options"
HOMEPAGE="http://md5deep.sourceforge.net/"
SRC_URI="https://github.com/jessek/hashdeep/archive/release-${PV}.tar.gz
	-> ${P}.tar.gz"

LICENSE="public-domain GPL-2"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~mips ppc ~ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

S=${WORKDIR}/hashdeep-release-${PV}

DOCS=( AUTHORS ChangeLog FILEFORMAT NEWS README.md TODO )

src_prepare() {
	eapply_user
	eautoreconf
}
