# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-i18n/tomoe/tomoe-0.6.0-r2.ebuild,v 1.2 2014/12/27 13:47:52 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )
inherit autotools eutils multilib python-single-r1

DESCRIPTION="Japanese handwriting recognition engine"
HOMEPAGE="http://tomoe.sourceforge.jp/"
SRC_URI="mirror://sourceforge/tomoe/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc hyperestraier mysql ruby python static-libs subversion"

RDEPEND=">=dev-libs/glib-2.4
	ruby? ( dev-ruby/ruby-glib2 )
	hyperestraier? ( app-text/hyperestraier )
	subversion? (
		>=dev-libs/apr-1
		dev-vcs/subversion
	)
	mysql? ( dev-db/mysql )
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:2[${PYTHON_USEDEP}]
		dev-python/pygtk:2[${PYTHON_USEDEP}]
	)"
#	test? ( app-dicts/uconv )

DEPEND="${DEPEND}
	dev-util/gtk-doc-am
	dev-util/intltool
	virtual/pkgconfig
	doc? ( dev-util/gtk-doc )"

REQUIRED_USE=${PYTHON_REQUIRED_USE}

RESTRICT="test"

pkg_setup() {
	if use python ; then
		python-single-r1_pkg_setup
	fi
}

src_prepare() {
	epatch \
		"${FILESDIR}/${P}-export-symbols.patch" \
		"${FILESDIR}/${P}-ldflags.patch" \
		"${FILESDIR}/${P}-glib232.patch"

	if ! use hyperestraier ; then
		sed -i -e "s/use_est=yes/use_est=no/" configure.ac || die
	fi
	if ! use mysql ; then
		sed -i -e "s/use_mysql=yes/use_mysql=no/" configure.ac || die
	fi
	if ! use subversion ; then
		sed -i -e "s/use_svn=yes/use_svn=no/" macros/svn.m4 || die
	fi

	eautoreconf
}

src_configure() {
	local myconf

	# --with-python b0rked hard
	unset PYTHON
	use python || myconf="${myconf} --without-python"

	econf \
		$(use_enable doc gtk-doc) \
		$(use_with ruby) \
		$(use_enable static-libs static) \
		$(use_enable ruby dict-ruby) \
		${myconf} || die
}

src_install() {
	emake DESTDIR="${D}" install || die "make install failed"

	find "${ED}/usr/$(get_libdir)/tomoe" \( -name '*.la' -o -name '*.a' \) -type f -delete || die
	if ! use static-libs ; then
		find "${ED}" -name '*.la' -type f -delete || die
	fi

	dodoc AUTHORS ChangeLog NEWS TODO || die
}
