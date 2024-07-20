# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby31 ruby32 ruby33"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG.md README.md ROADMAP.md SECURITY.md"

RUBY_FAKEGEM_GEMSPEC="nokogiri.gemspec"

RUBY_FAKEGEM_EXTENSIONS=(ext/nokogiri/extconf.rb)

inherit ruby-fakegem multilib

DESCRIPTION="Nokogiri is an HTML, XML, SAX, and Reader parser"
HOMEPAGE="https://nokogiri.org/"
SRC_URI="https://github.com/sparklemotion/nokogiri/archive/v${PV}.tar.gz -> ${P}-git.tgz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos"
IUSE="test"

RDEPEND="${RDEPEND}
	>=dev-libs/libxml2-2.12.7
	>=dev-libs/libxslt-1.1.39
	>=sys-libs/zlib-1.3.1
	virtual/libiconv"
DEPEND="${DEPEND}
	>=dev-libs/libxml2-2.12.7
	>=dev-libs/libxslt-1.1.39
	>=sys-libs/zlib-1.3.1
	virtual/libiconv"

ruby_add_rdepend ">=dev-ruby/racc-1.4:0"

ruby_add_bdepend "
	dev-ruby/mini_portile2:2.8
	>=dev-ruby/rexical-1.0.7
	dev-ruby/rdoc
	test? ( dev-ruby/minitest dev-ruby/rubyzip )"

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

	sed -e '/reporters/I s:^:#:' \
		-i test/helper.rb || die

	# There is no need for mini_portile2 to be a runtime dependency on Gentoo
	sed -i -e '/mini_portile2/ s:^:#:' ${RUBY_FAKEGEM_GEMSPEC} || die
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

each_ruby_test() {
	MT_NO_PLUGINS=1 \
	RUBY_MEMCHECK_RUNNING=true \
	${RUBY} -Ilib:.:test -e 'Dir["test/**/test_*.rb"].each {|f| require f}' || die
}
