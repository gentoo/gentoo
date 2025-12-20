# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

USE_RUBY="ruby32 ruby33 ruby34"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
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

ruby_add_bdepend "doc? ( dev-ruby/rspec:3 dev-ruby/yard )"

ruby_add_bdepend "test? ( dev-ruby/json
	dev-ruby/yajl-ruby )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/d' Rakefile spec/spec_helper.rb || die "Unable to remove bundler."

	# Remove unimportant rspec options not supported by rspec 2.6.
	rm .rspec || die

	# Remove specs specific to oj since we don't package oj yet.
	sed -i -e '/defaults to the best available gem/,/^    end/ s:^:#:' \
		-e '/Oj does not create symbols on parse/,/^    end/ s:^:#:' \
		-e '/with Oj.default_settings/,/^    end/ s:^:#:' \
		-e '/using one-shot parser/,/^  end/ s:^:#:' \
		-e '/jrjackson/askip "unpackaged"' \
		-e '/\(when JSON pure is already loaded\|can set adapter for a block\)/askip "JSON pure no longer exists"' \
		-e '/require.*pure/ s:^:#:' \
		spec/multi_json_spec.rb
}

each_ruby_test() {
	for t in spec/*_spec.rb; do
		${RUBY} -S rspec-3 ${t} || die
	done
}
