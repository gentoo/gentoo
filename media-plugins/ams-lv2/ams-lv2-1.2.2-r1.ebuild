# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
PYTHON_REQ_USE="threads(+)"
inherit waf-utils python-any-r1

# bundles ancient broken waf
WAF_VER=2.0.20

DESCRIPTION="A port of the AMS internal modules to LV2 plugins to create modular synthesizers"
HOMEPAGE="https://github.com/blablack/ams-lv2"
SRC_URI="
	https://github.com/blablack/ams-lv2/archive/${PV}.tar.gz -> ${P}.tar.gz
	https://waf.io/waf-${WAF_VER}
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-cpp/gtkmm:2.4
	dev-cpp/cairomm:0
	media-libs/lv2
	media-libs/lvtk[gtk2]
	sci-libs/fftw:3.0
	virtual/jack
"
DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	virtual/pkgconfig"

DOCS=( LICENSE README.md THANKS )

src_unpack() {
	unpack ${P}.tar.gz || die

	# we need newer version of waf to work with py3.11
	cp "${DISTDIR}/waf-${WAF_VER}" "${S}/waf" || die
	rm -r "${S}"/waflib || die
}
