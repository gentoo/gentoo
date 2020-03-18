# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Scheme implementation designed to be embeddable extension to C/C++ applications"
HOMEPAGE="http://sam.zoy.org/elk"
SRC_URI="http://sam.zoy.org/elk/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

src_configure() {
	econf --disable-static
}

src_compile() {
	# parallel build is broken
	emake -j1
}

# tests are run automatically during make and fail with default src_test
src_test() {
	echo "Tests already run during compile"
}

src_install() {
	# parallel install is broken
	emake -j1 DESTDIR="${D}" \
		docsdir="${EPREFIX}"/usr/share/doc/${PF} \
		examplesdir="${EPREFIX}"/usr/share/doc/${PF}/examples \
		install
	einstalldocs
	docompress -x /usr/share/doc/${PF}

	# no static archives
	find "${D}" -name '*.la' -delete || die
}
