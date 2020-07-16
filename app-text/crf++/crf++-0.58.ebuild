# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit autotools

MY_P="${P^^[crf]}"

DESCRIPTION="Yet Another CRF toolkit for segmenting/labelling sequential data"
HOMEPAGE="https://taku910.github.io/crfpp/"
SRC_URI="mirror://gentoo/${MY_P}.tar.gz"

LICENSE="|| ( BSD LGPL-2.1 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples static-libs"

S="${WORKDIR}/${MY_P}"

PATCHES=( "${FILESDIR}"/${PN}-automake-1.13.patch )
HTML_DOCS=( doc/. )

src_prepare() {
	sed -i \
		-e "/CFLAGS/s/-O3/${CFLAGS}/" \
		-e "/CXXFLAGS/s/-O3/${CXXFLAGS}/" \
		configure.in

	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_test() {
	local d
	for d in example/*; do
		cd "${d}"
		./exec.sh || die "failed test in ${d}"
		cd - >/dev/null
	done
}

src_install() {
	emake DESTDIR="${D}" install
	einstalldocs

	if use examples; then
		docompress -x /usr/share/doc/${PF}/example
		insinto /usr/share/doc/${PF}
		doins -r example
	fi

	if ! use static-libs; then
		find "${ED}" -name "*.la" -type f -delete || die
	fi
}
