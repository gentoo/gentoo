# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_BINDIR=""
RUBY_FAKEGEM_TASK_DOC="yard"

RUBY_FAKEGEM_DOCDIR="rdoc"
RUBY_FAKEGEM_EXTRADOC="README.md"

RUBY_FAKEGEM_GEMSPEC="multi_json.gemspec"

inherit ruby-fakegem

DESCRIPTION="A gem to provide swappable JSON backends"
HOMEPAGE="https://github.com/sferik/multi_json"
SRC_URI="https://github.com/sferik/multi_json/archive/v${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos ~x64-solaris"
IUSE="doc test"

ruby_add_rdepend "|| ( >=dev-ruby/json-1.4:* >=dev-ruby/yajl-ruby-1.0 )"

ruby_add_bdepend "doc? ( dev-ruby/yard )"

ruby_add_bdepend "test? ( dev-ruby/json
	dev-ruby/yajl-ruby )"

all_ruby_prepare() {
	# Bundler makes is impossible to deal only with packaged options.
	sed -e '/bundler/ s:^:#:' \
		-i test/test_helper.rb || die

	 # Avoid coverage dependencies
	sed -e '/mutant/ s:^:#:' \
		-e '/simplecov/,/^  end/ s:^:#:' \
		-i test/test_helper.rb || die
	sed -e '/cover/ s:^:#:' \
		-e '/Mutant/ s:^:#:' \
		-i test/multi_json/*.rb test/multi_json/*/*.rb test/multi_json/*/*/*.rb || die

	# Avoid integration tests requiring unpackaged providers
	rm -rf test/multi_json/integration || die

	# Avoid a test requiring ancient activesupport version.
	sed -e '/test_serializes_time_using_activesupport_format/askip "Too old"' \
		-e '/test_serializes_objects_that_define_to_hash/askip "Too old"' \
		-i test/multi_json/adapters/json_gem_test.rb || die
}

each_ruby_test() {
	CI=true ${RUBY} -Ilib:.:test -e "Dir['test/**/*.rb'].each{|f| require f}" || die
}
