# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-ruby/nokogiri/nokogiri-1.6.6.2.ebuild,v 1.2 2015/02/21 09:33:09 graaff Exp $

EAPI=5

USE_RUBY="ruby19 ruby20 ruby21 ruby22"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG.rdoc CHANGELOG.ja.rdoc README.rdoc README.ja.rdoc ROADMAP.md STANDARD_RESPONSES.md"

RUBY_FAKEGEM_EXTRAINSTALL="ext"

inherit ruby-fakegem eutils multilib

DESCRIPTION="Nokogiri is an HTML, XML, SAX, and Reader parser"
HOMEPAGE="http://nokogiri.org/"
LICENSE="MIT"
SRC_URI="https://github.com/sparklemotion/nokogiri/archive/v${PV}.tar.gz -> ${P}-git.tgz"

KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
SLOT="0"
IUSE=""

RDEPEND="${RDEPEND}
	>=dev-libs/libxml2-2.9.2:=
	dev-libs/libxslt
	virtual/libiconv"
DEPEND="${DEPEND}
	>=dev-libs/libxml2-2.9.2
	dev-libs/libxslt
	virtual/libiconv"

# The tests require _minitest_, not the virtual; what is shipped with
# Ruby 1.9 is *not* enough, unfortunately
ruby_add_bdepend "
	dev-ruby/hoe
	dev-ruby/rake-compiler
	dev-ruby/rexical
	dev-ruby/rdoc
	dev-ruby/racc
	test? ( dev-ruby/minitest )"

all_ruby_prepare() {
	sed -i \
		-e '/tasks\/cross_compile/s:^:#:' \
		-e '/:test.*prerequisites/s:^:#:' \
		-e '/license/ s:^:#:' \
		Rakefile || die
	# Remove the cross compilation options since they interfere with
	# native building.
	sed -i -e 's/cross_compile  = true/cross_compile = false/' Rakefile || die
	sed -i -e '/cross_config_options/d' Rakefile || die
}

each_ruby_configure() {
	NOKOGIRI_USE_SYSTEM_LIBRARIES=true \
		${RUBY} -Cext/${PN} extconf.rb \
		--with-zlib-include="${EPREFIX}"/usr/include \
		--with-zlib-lib="${EPREFIX}"/$(get_libdir) \
		--with-iconv-include="${EPREFIX}"/usr/include \
		--with-iconv-lib="${EPREFIX}"/$(get_libdir) \
		--with-xml2-include="${EPREFIX}"/usr/include/libxml2 \
		--with-xml2-lib="${EPREFIX}"/usr/$(get_libdir) \
		--with-xslt-dir="${EPREFIX}"/usr \
		--with-iconvlib=iconv \
		|| die "extconf.rb failed"
}

each_ruby_compile() {
	if ! [[ -f lib/nokogiri/css/tokenizer.rb ]]; then
		${RUBY} -S rake lib/nokogiri/css/tokenizer.rb || die "rexical failed"
	fi

	if ! [[ -f lib/nokogiri/css/parser.rb ]]; then
		${RUBY} -S rake lib/nokogiri/css/parser.rb || die "racc failed"
	fi

	emake -Cext/${PN} \
		V=1 \
		CFLAGS="${CFLAGS} -fPIC" \
		archflag="${LDFLAGS}" || die "make extension failed"
	cp -l ext/${PN}/${PN}$(get_modname) lib/${PN}/ || die
}

each_ruby_install() {
	# Clean up "ext" directory before installing it. nokogumbo expects
	# the header files and shared object to be in ext.
	rm -rf ext/java ext/nokogiri/*.o ext/nokogiri/{mkmf.log,Makefile} || die

	each_fakegem_install
}
