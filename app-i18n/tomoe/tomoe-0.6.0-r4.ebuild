# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
PYTHON_COMPAT=( python2_7 )
USE_RUBY="ruby24"

inherit autotools python-single-r1 ruby-single

DESCRIPTION="Japanese handwriting recognition engine"
HOMEPAGE="http://tomoe.osdn.jp/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="hyperestraier mysql python ruby ${USE_RUBY//ruby/ruby_targets_ruby} static-libs subversion"
RESTRICT="test"
REQUIRED_USE="python? ( ${PYTHON_REQUIRED_USE} )
	ruby? ( || ( ${USE_RUBY//ruby/ruby_targets_ruby} ) )"

_ruby_set_globals() {
	local ruby
	for ruby in ${USE_RUBY}; do
		RUBY_USEDEP="${RUBY_USEDEP}ruby_targets_${ruby}?,"
	done
	RUBY_USEDEP="${RUBY_USEDEP%,}"
}
_ruby_set_globals
unset -f _ruby_set_globals

RDEPEND="dev-libs/glib:2
	hyperestraier? ( app-text/hyperestraier )
	mysql? ( dev-db/mysql-connector-c:= )
	python? (
		${PYTHON_DEPS}
		dev-python/pygobject:2[${PYTHON_USEDEP}]
		dev-python/pygtk:2[${PYTHON_USEDEP}]
	)
	ruby? (
		${RUBY_DEPS}
		dev-ruby/ruby-glib2[${RUBY_USEDEP}]
	)
	subversion? ( dev-vcs/subversion )"
DEPEND="${RDEPEND}
	dev-util/glib-utils
	dev-util/gtk-doc-am
	dev-util/intltool
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-export-symbols.patch
	"${FILESDIR}"/${PN}-glib-2.32.patch
	"${FILESDIR}"/${PN}-ruby19.patch
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
	local ruby
	for ruby in ${RUBY_TARGETS_PREFERENCE}; do
		if use ruby_targets_${ruby}; then
			break
		fi
	done

	econf \
		$(use_enable ruby dict-ruby) \
		$(use_enable static-libs static) \
		$(use_with python python "") \
		$(use_with ruby ruby "$(type -p ${ruby})") \
		--with-svn-include="${EPREFIX}"/usr/include \
		--with-svn-lib="${EPREFIX}"/usr/$(get_libdir)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
