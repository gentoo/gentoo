# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
USE_RUBY="ruby27"

inherit autotools ruby-utils

DESCRIPTION="Japanese handwriting recognition engine"
HOMEPAGE="http://tomoe.osdn.jp/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="hyperestraier mysql ruby ${USE_RUBY//ruby/ruby_targets_ruby} subversion"
RESTRICT="test"
REQUIRED_USE="ruby? ( ^^ ( ${USE_RUBY//ruby/ruby_targets_ruby} ) )"

RDEPEND="dev-libs/glib:2
	hyperestraier? ( app-text/hyperestraier )
	mysql? ( dev-db/mysql-connector-c:= )
	ruby? (
		$(for ruby in ${USE_RUBY}; do
			echo "ruby_targets_${ruby}? (
				$(_ruby_implementation_depend "${ruby}")
				dev-ruby/ruby-glib2[ruby_targets_${ruby}]
			)"
		done)
	)
	subversion? ( dev-vcs/subversion )"
DEPEND="${RDEPEND}"
BDEPEND="dev-util/glib-utils
	dev-util/gtk-doc-am
	dev-util/intltool
	virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PN}-gentoo.patch
	"${FILESDIR}"/${PN}-export-symbols.patch
	"${FILESDIR}"/${PN}-glibc-2.32.patch
	"${FILESDIR}"/${PN}-glib-2.32.patch
	"${FILESDIR}"/${PN}-ruby19.patch
)

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
	for ruby in ${USE_RUBY}; do
		if use ruby_targets_${ruby}; then
			break
		fi
	done

	econf \
		$(use_enable ruby dict-ruby) \
		$(use_with ruby ruby "$(type -P ${ruby})") \
		--disable-static \
		--without-python \
		--with-svn-include="${EPREFIX}"/usr/include \
		--with-svn-lib="${EPREFIX}"/usr/$(get_libdir)
}

src_install() {
	default
	find "${ED}" -name '*.la' -delete || die
}
