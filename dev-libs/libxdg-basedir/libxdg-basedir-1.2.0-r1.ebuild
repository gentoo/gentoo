# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit autotools eutils

DESCRIPTION="Small library to access XDG Base Directories Specification paths"
HOMEPAGE="https://github.com/devnev/libxdg-basedir"
SRC_URI="https://github.com/devnev/libxdg-basedir/archive/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm arm64 hppa ppc ppc64 x86 ~amd64-linux ~x64-macos ~x86-solaris"
IUSE="doc static-libs"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	epatch "${FILESDIR}/${P}-buffer-overflow.patch"

	eautoreconf
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
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
		dohtml -r doc/html/*
	fi

	find "${D}" -type f -name '*.la' -delete
}
