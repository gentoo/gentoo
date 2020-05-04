# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

USE_RUBY="ruby24 ruby25 ruby26 ruby27"

RUBY_FAKEGEM_RECIPE_TEST="rspec3"
RUBY_FAKEGEM_TASK_DOC="yard"

RUBY_FAKEGEM_EXTRADOC="README.md"
RUBY_FAKEGEM_DOCDIR="doc docs"

RUBY_FAKEGEM_EXTRAINSTALL="templates"

RUBY_FAKEGEM_GEMSPEC="yard.gemspec"

inherit ruby-fakegem

DESCRIPTION="Documentation generation tool for the Ruby programming language"
HOMEPAGE="https://yardoc.org/"

# The gem lakes the gemspec file needed to pass tests.
SRC_URI="https://github.com/lsegal/yard/archive/v${PV}.tar.gz -> ${P}-git.tgz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

ruby_add_bdepend "doc? ( || ( dev-ruby/maruku dev-ruby/rdiscount dev-ruby/bluecloth dev-ruby/kramdown ) )"

ruby_add_bdepend "test? ( dev-ruby/rack )"

all_ruby_prepare() {
	sed -i -e '/[Bb]undler/ s:^:#:' spec/spec_helper.rb || die

	sed -i -e '/samus/I s:^:#:' Rakefile || die

	sed -i -e 's/git ls-files/find/' ${RUBY_FAKEGEM_GEMSPEC} || die

	# Avoid specs that make assumptions on load ordering that are not
	# true for us. This may be related to how we install in Gentoo. This
	# also drops a test requirement on dev-ruby/rack.
	rm -f spec/cli/server_spec.rb || die

	# Avoid specs that only work with bundler
	sed -i -e '/#initialize/,/^  end/ s:^:#:' spec/cli/yri_spec.rb || die
	sed -e '/overwrites options with data in/askip "wrong assumptions on file access"' \
		-e '/loads any gem plugins starting with/askip "wrong assumptions on file access"' \
		-i spec/config_spec.rb || die

	# Avoid redcarpet-specific spec that is not optional
	sed -i -e '/autolinks URLs/askip "make redcarpet optional"' spec/templates/helpers/html_helper_spec.rb || die

	# Avoid asciidoc-specific spec that is not optional
	sed -i -e '/\(AsciiDoc specific\|AsciiDoc header\)/askip "skipping asciidoc test"' spec/templates/helpers/html_helper_spec.rb || die
}
