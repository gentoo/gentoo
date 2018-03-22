# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

# disable automatic phase exports and deps
DISTUTILS_OPTIONAL=1
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 prefix

DESCRIPTION="CMU Speech Recognition engine"
HOMEPAGE="http://cmusphinx.sourceforge.net/"
SRC_URI="mirror://sourceforge/cmusphinx/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc python static-libs"

RDEPEND=">=app-accessibility/sphinxbase-0.7[static-libs?,python?,${PYTHON_USEDEP}]
	python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

# Due to generated Python setup.py.
AUTOTOOLS_IN_SOURCE_BUILD=1

PATCHES=(
	"${FILESDIR}/${PN}-0.8-heap-fix.patch"
	"${FILESDIR}/${PN}-0.8-libutil.patch"
)

src_prepare() {
	eprefixify 'python/setup.py'
	default
}

src_compile() {
	default

	if use python; then
		cd python || die
		distutils-r1_src_compile
	fi
}

src_install() {
	local DOCS=( AUTHORS ChangeLog NEWS README )
	default

	if use doc; then
		HTML_DOCS="doc/s3 doc/*.html doc/s3* doc/*.gif" einstalldocs
	fi

	if use python; then
		unset DOCS

		cd "${S}"/python || die
		distutils-r1_src_install
	fi

	rm -rf "${ED}"usr/share/sphinx3/doc || die # duplicate of html dir
}
