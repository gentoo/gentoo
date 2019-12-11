# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_DOCDIR="doc"
RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md"

inherit ruby-fakegem eutils

DESCRIPTION="A fast and liberal HTML parser for Ruby"
HOMEPAGE="https://wiki.github.com/hpricot/hpricot"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 hppa ia64 ppc ppc64 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "dev-ruby/rake
	dev-ruby/rdoc
	dev-ruby/rake-compiler"

ruby_add_rdepend "dev-ruby/fast_xs"

# Probably needs the same jdk as JRuby but I'm not sure how to express
# that just yet.
DEPEND+=" dev-util/ragel"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' Rakefile || die

	# Fix encoding assumption of environment for Ruby 1.9.
	# https://github.com/hpricot/hpricot/issues/52
	# sed -i -e '1 iEncoding.default_external=Encoding::UTF_8 if RUBY_VERSION =~ /1.9/' test/load_files.rb || die

	# Avoid unneeded dependency on git.
	sed -i -e '/^REV/ s/.*/REV = "6"/' Rakefile || die

	# Fix int size warning
	sed -i -e 's/te - ts/(int)(te - ts)/' ext/hpricot_scan/hpricot_css.rl || die
}

each_ruby_prepare() {
	pushd .. &>/dev/null
	epatch "${FILESDIR}"/${P}-fast_xs.patch
	popd .. &>/dev/null
}

each_ruby_configure() {
	${RUBY} -Cext/hpricot_scan extconf.rb || die "hpricot_scan/extconf.rb failed"
}

each_ruby_compile() {
	local modname=$(get_modname)

	${RUBY} -S rake ragel || die
	emake V=1 -Cext/hpricot_scan CFLAGS="${CFLAGS} -fPIC" archflag="${LDFLAGS}"
	cp ext/hpricot_scan/hpricot_scan${modname} lib/ || die
}
