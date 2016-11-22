# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_{4,5}} )

inherit autotools eutils python-r1

DESCRIPTION="Framework to easy access to the Prelude database"
HOMEPAGE="https://www.prelude-siem.org"
SRC_URI="https://www.prelude-siem.org/pkg/src/3.0.0/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc python mysql postgres sqlite"

REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/libgcrypt:0=
	net-libs/gnutls
	dev-libs/libprelude
	python? ( ${PYTHON_DEPS} )
	mysql? ( virtual/libmysqlclient )
	postgres? ( dev-db/postgresql:* )
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}
	doc? ( dev-util/gtk-doc )
	sys-devel/flex
	virtual/yacc
	>=dev-lang/swig-3.0.7
	virtual/pkgconfig"

src_prepare() {
	default_src_prepare

	mv "${S}/configure.in" "${S}/configure.ac" || die "mv failed"

	eautoreconf
}

src_configure() {
	local python2_configure=--without-python2
	local python3_configure=--without-python3

	chk_python() {
		if [[ ${EPYTHON} == python2* ]]; then
			python2_configure=--with-python2
		elif [[ ${EPYTHON} == python3* ]]; then
			python3_configure=--with-python3
		fi
	}

	if use python; then
		python_foreach_impl chk_python
	fi

	econf \
		--enable-easy-bindings \
		--with-swig \
		$(use_enable doc gtk-doc) \
		${python2_configure} \
		${python3_configure} \
		$(use_with mysql) \
		$(use_with postgres postgresql) \
		$(use_with sqlite sqlite3)
}

src_install() {
	default_src_install
	prune_libtool_files --modules
}
