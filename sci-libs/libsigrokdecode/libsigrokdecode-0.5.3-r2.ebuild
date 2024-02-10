# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"

PYTHON_COMPAT=( python3_{9..11} )
inherit autotools python-single-r1

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="git://sigrok.org/${PN}"
	inherit git-r3
else
	SRC_URI="https://sigrok.org/download/source/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

DESCRIPTION="Provide (streaming) protocol decoding functionality"
HOMEPAGE="https://sigrok.org/wiki/Libsigrokdecode"

LICENSE="GPL-3"
SLOT="0/4"
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

	# bug #794592
	sed -i -e "s/\[SRD_PKGLIBS\],\$/& [python-${EPYTHON#python}-embed], [python-${EPYTHON#python}],/" configure.ac || die

	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static) PYTHON3="${PYTHON}"
}

src_test() {
	emake check
}

src_install() {
	default
	python_optimize "${D}"/usr/share/libsigrokdecode/decoders
	find "${D}" -name '*.la' -type f -delete || die
}
