# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C++ functions matching the interface and behavior of python string methods"
HOMEPAGE="https://github.com/imageworks/pystring"

if [[ "${PV}" == "9999" ]];  then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/imageworks/pystring.git"
else
	SRC_URI="https://github.com/imageworks/pystring/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

BDEPEND="
	virtual/libc
	sys-devel/libtool
"
RESTRICT="mirror"

LICENSE="BSD"
SLOT="0"

src_compile() {
	sed -i -e "s|-O3|${CXXFLAGS}|g" Makefile || die
	emake LIBDIR="${S}" install

	# Fix header location
	mkdir ${S}/pystring || die
	mv ${S}/pystring.h ${S}/pystring || die
}

src_install() {
	dolib.so ${S}/libpystring.so{,.0{,.0.0}}
	doheader -r ${S}/pystring
}
