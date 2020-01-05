# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{2_7,3_6} )
PYTHON_REQ_USE='wide-unicode(+)'
DISTUTILS_OPTIONAL=1
inherit autotools distutils-r1

DESCRIPTION="An open-source braille translator and back-translator"
HOMEPAGE="https://github.com/liblouis/liblouis"
SRC_URI="https://github.com/liblouis/liblouis/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="alpha amd64 ~arm ~arm64 ia64 ppc ppc64 ~sparc x86"
IUSE="python"
BDEPEND="sys-apps/help2man"
RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

src_prepare() {
	default

	if use python; then
		pushd python > /dev/null
		distutils-r1_src_prepare
		popd > /dev/null
	fi
	eautoreconf
}

src_configure() {
	econf --enable-ucs4
}

src_compile() {
	default

	if use python; then
		pushd python > /dev/null
		# setup.py imports liblouis to get the version number,
		# and this causes the shared library to be dlopened
		# at build-time.  Hack around it with LD_PRELOAD.
		# Thanks ArchLinux.
		LD_PRELOAD+=':../liblouis/.libs/liblouis.so'
			distutils-r1_src_compile
		popd > /dev/null
	fi
}

src_install() {
	emake DESTDIR="${D}" install

	if use python; then
		pushd python > /dev/null
		LD_PRELOAD+=':../liblouis/.libs/liblouis.so' \
			distutils-r1_src_install
		popd > /dev/null
	fi

	DOCS=( README AUTHORS NEWS ChangeLog doc/liblouis.txt )
	HTML_DOCS=( doc/liblouis.html )
	einstalldocs
}
