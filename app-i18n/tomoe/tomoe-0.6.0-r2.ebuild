# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 )

inherit autotools ltprune python-single-r1

DESCRIPTION="Japanese handwriting recognition engine"
HOMEPAGE="http://tomoe.osdn.jp/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE="hyperestraier mysql python ruby static-libs subversion"
RESTRICT="test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )"

RDEPEND="dev-libs/glib:2
	hyperestraier? ( app-text/hyperestraier )
	mysql? ( virtual/libmysqlclient )
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:2[${PYTHON_USEDEP}]
		dev-python/pygtk:2[${PYTHON_USEDEP}]
	)
	ruby? ( dev-ruby/ruby-glib2 )
	subversion? ( dev-vcs/subversion )"
DEPEND="${RDEPEND}
	dev-util/gtk-doc-am
	dev-util/intltool
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-export-symbols.patch
	"${FILESDIR}"/${PN}-glib-2.32.patch
)

pkg_setup() {
	use python && python-single-r1_pkg_setup
}

src_prepare() {
	sed -i \
		-e "s/use_est=yes/use_est=$(usex hyperestraier)/" \
		-e "s/use_mysql=yes/use_mysql=$(usex mysql)/" \
		configure.ac

	sed -i "s/use_svn=yes/use_svn=$(usex subversion)/" macros/svn.m4

	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable ruby dict-ruby) \
		$(use_enable static-libs static) \
		$(use_with python python "") \
		$(use_with ruby) \
		--with-svn-include="${EPREFIX}"/usr/include \
		--with-svn-lib="${EPREFIX}"/usr/$(get_libdir)
}

src_install() {
	default
	prune_libtool_files --modules
}
