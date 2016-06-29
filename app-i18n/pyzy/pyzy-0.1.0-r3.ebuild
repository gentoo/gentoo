# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit autotools eutils flag-o-matic python-any-r1

PY_DATABASE=${PN}-database-1.0.0
DESCRIPTION="The Chinese PinYin and Bopomofo conversion library"
HOMEPAGE="https://github.com/pyzy/pyzy"
SRC_URI="https://pyzy.googlecode.com/files/${P}.tar.gz
	https://pyzy.googlecode.com/files/${PY_DATABASE}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="boost doc opencc test"

RDEPEND="dev-libs/glib:2
	dev-db/sqlite:3
	sys-apps/util-linux
	boost? (
		>=dev-libs/boost-1.61.0-r100:=
		>=sys-devel/boost-m4-0.4_p20160328 )
	opencc? ( app-i18n/opencc )"

DEPEND="${RDEPEND}
	${PYTHON_DEPS}
	doc? ( app-doc/doxygen )"

# Currently it fails to build test code
RESTRICT="test"

PATCHES=(
	"${FILESDIR}/${PN}-dont-download-dictionary-file.patch"
	"${FILESDIR}/${PN}-support-opencc-1.0.0.patch"
)

src_prepare() {
	default

	mv ../db ./data/db/open-phrase/ || die
	sed -i -e 's/-std=c++0x/-std=c++11/' src/Makefile.am || die
	if use boost; then
		rm -rf m4/boost.m4 || die
	fi

	eautoreconf
}

src_configure() {
	# build with C++11 due to dev-libs/boost ABI switch. Do _NOT_
	# remove this, unless the build system enables C++11 by itself.
	append-cxxflags -std=c++11

	econf \
		--enable-db-open-phrase \
		--enable-db-android \
		$(use_enable boost) \
		$(use_enable opencc) \
		$(use_enable test tests)
}

src_install() {
	default
	use doc && dodoc -r docs/html
	prune_libtool_files --all
}
