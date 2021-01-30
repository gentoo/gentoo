# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )
inherit python-single-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3 autotools
else
	SRC_URI="https://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Provide (streaming) protocol decoding functionality"
HOMEPAGE="https://sigrok.org/wiki/Libsigrokdecode"

LICENSE="GPL-3"
SLOT="0/9999"
IUSE="static-libs"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="${PYTHON_DEPS}
	>=dev-libs/glib-2.34.0
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
"

src_prepare() {
	default
	[[ ${PV} == *9999* ]] && eautoreconf

	# Only a test program (not installed, and not used by src_test)
	# is used by libsigrok, so disable it to avoid the compile.
	sed -i \
		-e '/build_runtc=/s:yes:no:' \
		configure || die
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_test() {
	emake check
}

src_install() {
	default
	find "${D}" -name '*.la' -type f -delete || die
}
