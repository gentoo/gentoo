# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
AT_M4DIR="config"
PYTHON_COMPAT=( python3_{6,7,8} )
DISTUTILS_OPTIONAL=1
inherit autotools distutils-r1 git-r3

DESCRIPTION="simplified, portable interface to several low-level networking routines"
HOMEPAGE="https://github.com/ofalk/libdnet"
EGIT_REPO_URI="https://github.com/ofalk/libdnet"
LICENSE="LGPL-2"

SLOT="0"
KEYWORDS=""
IUSE="python static-libs test"

DEPEND="
	python? ( ${PYTHON_DEPS} )
"
RDEPEND="
	${DEPEND}
"
RESTRICT="test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"
DOCS=( README.md THANKS TODO )

src_prepare() {
	default

	sed -i \
		-e 's/libcheck.a/libcheck.so/g' \
		-e 's|AM_CONFIG_HEADER|AC_CONFIG_HEADERS|g' \
		configure.ac || die
	sed -i \
		-e 's|-L$libdir ||g' \
		dnet-config.in || die
	sed -i \
		-e '/^SUBDIRS/s|python||g' \
		Makefile.am || die

	eautoreconf

	if use python; then
		cd python
		distutils-r1_src_prepare
	fi
}

src_configure() {
	econf \
		$(use_with python) \
		$(use_enable static-libs static)
}

src_compile() {
	default
	if use python; then
		cd python
		distutils-r1_src_compile
	fi
}

src_install() {
	default
	if use python; then
		cd python
		unset DOCS
		distutils-r1_src_install
	fi
	find "${D}" -name '*.la' -delete || die
}
