# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools

DESCRIPTION="Default MyPaint brushes"
HOMEPAGE="https://github.com/Jehan/mypaint-brushes"
SRC_URI="https://github.com/Jehan/mypaint-brushes/archive/v1.3.0.tar.gz -> ${P}.tar.gz"

LICENSE="CC0-1.0"
SLOT="1.0"  # due to pkgconfig name "mypaint-brushes-1.0"
KEYWORDS="amd64 arm64 ~ppc64 x86"
IUSE=""

DOCS=( AUTHORS NEWS README.md )  # to exclude README symlink

src_prepare() {
	eapply_user
	eautoreconf
}
