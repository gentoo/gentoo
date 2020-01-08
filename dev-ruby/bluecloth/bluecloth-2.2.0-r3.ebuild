# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

USE_RUBY="ruby24 ruby25 ruby26"

RUBY_FAKEGEM_RECIPE_DOC="rdoc"
RUBY_FAKEGEM_EXTRADOC="History.rdoc README.rdoc"

RUBY_FAKEGEM_RECIPE_TEST="rspec"

inherit multilib ruby-fakegem eutils

DESCRIPTION="A Ruby implementation of Markdown"
HOMEPAGE="http://www.deveiate.org/projects/BlueCloth"

LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 arm ~arm64 ~hppa ia64 ppc ppc64 ~sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

DEPEND+=" doc? ( dev-lang/perl )"

ruby_add_bdepend "
	test? (
		dev-ruby/diff-lcs
		dev-ruby/tidy-ext
	)"

all_ruby_prepare() {
	# for Ruby 1.9.2 and 2.2.x compatibility
	sed -i -e '1i $: << "."' \
		-e 's/Config/RbConfig/' Rakefile || die
}

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
}

all_ruby_compile() {
	pod2man --center --release --name bluecloth --utf8 bluecloth.1.pod bluecloth.1 || die

	all_fakegem_compile
}

each_ruby_compile() {
	emake -Cext
	cp ext/bluecloth_ext$(get_modname) lib/ || die
}

all_ruby_install() {
	doman man/man1/bluecloth.1

	all_fakegem_install
}
