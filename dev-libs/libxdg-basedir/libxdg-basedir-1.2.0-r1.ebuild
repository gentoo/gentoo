# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Small library to access XDG Base Directories Specification paths"
HOMEPAGE="https://github.com/devnev/libxdg-basedir"
SRC_URI="https://github.com/devnev/libxdg-basedir/archive/${P}.tar.gz"
S="${WORKDIR}/${PN}-${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~hppa ppc ppc64 x86 ~amd64-linux ~x64-macos ~x86-solaris"
IUSE="doc"

BDEPEND="doc? ( app-doc/doxygen )"

PATCHES=(
	"${FILESDIR}"/${P}-buffer-overflow.patch
)

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable doc doxygen-html)
}

src_compile() {
	emake

	if use doc; then
		emake doxygen-doc
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	if use doc; then
		docinto html
		dodoc -r doc/html/*
	fi

	find "${ED}" -type f -name '*.la' -delete
}
